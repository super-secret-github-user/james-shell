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
            nettools
          ] else [ ];
        x86linux_stuff =
          if system == "x86_64-linux" then with pkgs; [
            cudaPackages.cudatoolkit
            cudaPackages.cudnn_8_4_1
          ] else [ ];
        mac_stuff =
          if pkgs.stdenv.isDarwin then with pkgs; [
            darwin.apple_sdk.frameworks.Security
            pkgconfig
          ] else [ ];
      in
      rec {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; linux_stuff ++ mac_stuff ++ x86linux_stuff ++ [
            cairo
            cmake
            curl
            ffmpeg
            gcc
            git
            gobject-introspection
            gst_all_1.gst-devtools
            gst_all_1.gst-libav
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-rtsp-server
            gst_all_1.gstreamer
            gzip
            htop
            libffi
            libjpeg
            libpng
            libxcrypt
            llvm_10
            lsof
            netcat
            openssh
            openssl
            postgresql_15
            protobuf
            rustup
            sccache
            swig
            tmux
            which
            x264
            x265
            zip
            zlib
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


