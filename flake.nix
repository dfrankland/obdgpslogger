{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      obdgpslogger-tcp = (with pkgs; stdenv.mkDerivation rec {
        version = "0.16";
        name = "obdgpslogger-tcp-${version}";

        src = ./.;

        nativeBuildInputs = [ cmake ];
        buildInputs = [ ];

        buildPhase = ''
          mkdir build
          cd build
          cmake ..
          cd ..
          make
          make install
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp ../bin/* $out/bin/
        '';
      }
      );
    in
    rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = obdgpslogger-tcp;
      devShell = pkgs.mkShell {
        buildInputs = [
          obdgpslogger-tcp
        ];
      };
    }
  );
}
