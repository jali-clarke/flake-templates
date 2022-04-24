{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        ghc = pkgs.haskell.packages.ghc922;

        cabalWrapped = pkgs.writeShellScriptBin "cabal" ''
          ${pkgs.hpack}/bin/hpack && exec ${pkgs.cabal-install}/bin/cabal "$@"
        '';

        format-all = pkgs.writeShellScriptBin "format-all" ''
          shopt -s globstar
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt . && ${pkgs.ormolu}/bin/ormolu -i {app,src,test}/**/*.hs
        '';

        hello-world = pkgs.haskellPackages.callCabal2nix "hello-world" ./. { };
      in
      {
        defaultPackage = hello-world;
        packages = {
          inherit hello-world;
        };

        devShell = pkgs.mkShell {
          inputsFrom = [ hello-world.env ];
          packages = [
            cabalWrapped
            format-all
          ];
        };
      }
    );
}
