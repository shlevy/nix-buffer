{ root }:
let
  defnix = root + "/default.nix";
  pkgs = import <nixpkgs> {};
  inherit (pkgs) writeText runCommand;
  inherit (pkgs.lib) overrideDerivation isDerivation;
  inherit (pkgs.emacsPackagesNg) inherit-local;
  inherit (pkgs.nixBufferBuilders) withPackages;
  drv = import (builtins.toPath defnix) {};
  packageEnv = pkg: overrideDerivation pkg (old: {
    phases = [ "installPhase" ];
    # TODO: run configurePhase and shellHook here
    installPhase = "${pkgs.jq}/bin/jq -n env > $out";
  });
  withPackage = pkg: runCommand "dir-locals.el" {
    env = packageEnv pkg;
  } ''
    cp ${./dir-locals.el.in} $out
    substituteAllInPlace $out
  '';
in if builtins.pathExists defnix && isDerivation drv then
  withPackage drv
else {}
