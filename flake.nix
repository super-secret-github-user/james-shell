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
        linux_stuff =
          if pkgs.stdenv.isLinux then with pkgs; [
            cudaPackages.cudatoolkit
            cudaPackages.cudnn_8_4_1
            nettools
            openssl
          ] else [ ];
      in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; linux_stuff ++ [
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


