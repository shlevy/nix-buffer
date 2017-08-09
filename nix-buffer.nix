{ root }:
let
  defnix = root + "/default.nix";
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib writeText runCommand;
  inherit (pkgs.emacsPackagesNg) inherit-local;
  inherit (pkgs.nixBufferBuilders) withPackages;
  drv = (import (builtins.toPath defnix) {});
in if builtins.pathExists defnix && builtins.hasAttr "buildInputs" drv then
  withPackages drv.buildInputs
else {}
