{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        cabalWrapped = pkgs.writeShellScriptBin "cabal" ''
          ${pkgs.hpack}/bin/hpack
          exec ${pkgs.cabal-install}/bin/cabal "$@"
        '';
      in
      {
        defaultPackage = pkgs.haskellPackages.callPackage ./hello-world.nix { };
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.nixpkgs-fmt

            cabalWrapped
            pkgs.cabal2nix
            pkgs.ghc
            pkgs.hpack
            pkgs.wget
          ];
        };
      }
    );
}
