{ root }:
let
  defnix = root + "/default.nix";
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib writeText runCommand;
  inherit (pkgs.emacsPackagesNg) inherit-local;
  inherit (pkgs.nixBufferBuilders) withPackages;
  drv = import (builtins.toPath defnix) {};
  packageEnv = pkg: lib.overrideDerivation pkg (old: {
    phases = [ "installPhase" ];
    # TODO: run configurePhase and shellHook here
    installPhase = ''${pkgs.jq}/bin/jq -n env > $out'';
  });
  withPackage = pkg: runCommand "dir-locals.el" {
    env = packageEnv pkg;
    inheritlocal = "${inherit-local}/share/emacs/site-lisp/elpa/inherit-local-${inherit-local.version}/inherit-local.elc";
  } ''
    cp ${./dir-locals.el.in} $out
    substituteAllInPlace $out
  '';
in if builtins.pathExists defnix then
  withPackage drv
else {}
