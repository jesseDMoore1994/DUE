{
  description = "A Flake for the DUE";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree {
           due = pkgs.stdenv.mkDerivation {
            pname = "DUE";
            version = "master";
            src = ./.;
            propagatedBuildInputs = [
              pkgs.docker
              pkgs.rsync
            ];
	    installPhase = ''
	      mkdir -p $out/bin
	      mv due libdue templates $out/bin
	    '';
          };
        };
        defaultPackage = packages.due;
        apps.due = flake-utils.lib.mkApp { drv = packages.due; };
        defaultApp = apps.due;
      }
    );
}
