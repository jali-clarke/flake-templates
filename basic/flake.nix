{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }: {
    overlays.default = final: prev: {
      hello-world = final.callPackage ./default.nix { };
    };
  } // flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
    in
    {
      packages.default = pkgs.hello-world;

      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nixpkgs-fmt
        ];
      };
    }
  );
}
