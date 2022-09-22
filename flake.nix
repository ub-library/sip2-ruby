{
  description = "A devShell that imports shell.nix";

  inputs.nixpkgs.url = "nixpkgs/nixpkgs-22.05-darwin";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          devShell = import ./shell.nix { inherit pkgs; };
        }
    );
}
