{ root }:
let
  defnix = root + "/default.nix";
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib writeText runCommand;
  inherit (pkgs.emacsPackagesNg) inherit-local;
  inherit (pkgs.nixBufferBuilders) withPackages;
in if builtins.pathExists defnix then
  withPackages (import defnix).buildInputs
else {}
