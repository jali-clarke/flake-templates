{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    {
      overlays.default = final: prev: rec {
        hello-world = haskellPackages.hello-world;

        haskellPackages = prev.haskellPackages // {
          hello-world = final.haskellPackages.callCabal2nix "hello-world" ./. { };
        };
      };
    } // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };

        cabalWrapped = pkgs.writeShellScriptBin "cabal" ''
          ${pkgs.hpack}/bin/hpack && exec ${pkgs.cabal-install}/bin/cabal "$@"
        '';

        format-all = pkgs.writeShellScriptBin "format-all" ''
          shopt -s globstar
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt . && ${pkgs.ormolu}/bin/ormolu -i {app,src,test}/**/*.hs
        '';
      in
      {
        packages.default = pkgs.hello-world;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ pkgs.hello-world.env ];
          packages = [
            cabalWrapped
            format-all
          ];
        };
      }
    );
}
