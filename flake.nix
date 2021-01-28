{
  description = "NixOps Flake";

  inputs = {
    nixpkgs = {
      url = github:NixOS/nixpkgs/master;
    };

    nixops = {
      url = github:NixOS/nixops;
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nixops }:
    flake-utils.lib.eachDefaultSystem
      (system:
        with nixpkgs.legacyPackages.${system};
        {
          devShell = pkgs.mkShell {
            buildInputs = [ nixops.defaultPackage.${system} ];
          };
        }
      );
}
