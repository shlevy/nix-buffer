{ root }:
let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) writeText runCommand;
  inherit (pkgs.lib) overrideDerivation isDerivation;
  inherit (pkgs.emacsPackagesNg) inherit-local;
  inherit (pkgs.nixBufferBuilders) withPackages;

  defnix = builtins.toPath (root + "/default.nix");
  drv' = import defnix;
  drv = if (builtins.isFunction (import defnix)) then import defnix {}
        else import defnix;

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
