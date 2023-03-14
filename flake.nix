{
  description = "Flake utils demo";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        f = b: l: if b then with pkgs; l else [ ];
        linux_stuff =
          f pkgs.stdenv.isLinux [
            cudaPackages.cudatoolkit
            cudaPackages.cudnn_8_4_1
            nettools
            openssl
          ];
        mac_stuff = f pkgs.stdenv.isDarwin [
          darwin.apple_sdk.frameworks.Security
        ];
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs =  with pkgs; linux_stuff ++ mac_stuff ++ [
            openssh
            git
            curl
            gzip
            zip
            cmake
            gcc
            libffi
            which
            htop
            zlib
            swig
            lsof
            netcat
            x264
            x265
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
            gst_all_1.gst-devtools
            gst_all_1.gst-rtsp-server
            libjpeg
            libpng
            ffmpeg
            tmux
            postgresql_15
            llvm_10
            cairo
            libxcrypt
            gobject-introspection
            rustup
            protobuf
            sccache
          ];
          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
          shellHook = ''
            LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/
          '';
        };
      }
    );
}


