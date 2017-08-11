with import <nixpkgs> { };

lib.overrideDerivation emacsPackagesNg.melpaPackages.nix-buffer (oldAttrs: {
  src = ./.;
  buildInputs = oldAttrs.buildInputs
    ++ [ emacsPackagesNg.melpaPackages.projectile ];
})
