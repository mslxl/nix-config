{
  description = "Tauri Javascript App";

  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";

    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    fenix,
    android-nixpkgs,
    ...
  } @ inputs:
    utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [fenix.overlays.default];
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      commonBulidInputs = with pkgs; [
        # js
        nodejs
        nodejs.pkgs.pnpm

        cargo-tauri
        pkg-config
        openssl
      ];

      desktopBuildInputs =
        commonBulidInputs
        ++ (with pkgs.fenix; [
          (combine [
            complete.cargo
            complete.rustc
            complete.rust-src
            complete.clippy
            complete.rustfmt
          ])
        ])
        ++ (pkgs.lib.optional pkgs.stdenv.isLinux (with pkgs; [
          gtk3
          webkitgtk
          dbus
          libayatana-appindicator.dev
          alsa-lib.dev
        ]))
        ++ (pkgs.lib.optional pkgs.stdenv.isDarwin (with pkgs; [
          libiconv
        ]));

      androidJdk = pkgs.jdk17;

      androidPackage = android-nixpkgs.sdk.${pkgs.system} (
        sdkPkgs:
          with sdkPkgs; [
            platform-tools
            ndk-26-1-10909125
            build-tools-35-0-0
            platforms-android-36

            cmdline-tools-latest
          ]
      );

      androidBuildInputs =
        commonBulidInputs
        ++ (with pkgs.fenix; [
          (combine [
            complete.cargo
            complete.rustc
            targets.aarch64-linux-android.latest.rust-std
            targets.armv7-linux-androideabi.latest.rust-std
            targets.i686-linux-android.latest.rust-std
            targets.x86_64-linux-android.latest.rust-std
          ])
        ])
        ++ (with pkgs; [
          gnumake
          androidPackage
          androidJdk
        ]);
    in {
      # Used by `nix develop`
      formatter = pkgs.alejandra;
      devShells = rec {
        desktop = pkgs.mkShell {
          buildInputs = desktopBuildInputs;
          # Specify the rust-src path (many editors rely on this)
          RUST_SRC_PATH = "${pkgs.fenix.complete.rust-src}/lib/rustlib/src/rust/library";
        };
        default = desktop;

        android = pkgs.mkShell {
          buildInputs = androidBuildInputs;
          # Specify the rust-src path (many editors rely on this)
          RUST_SRC_PATH = "${pkgs.fenix.complete.rust-src}/lib/rustlib/src/rust/library";
          JAVA_HOME = "${androidJdk}";
          ANDROID_HOME = "${androidPackage}/share/android-sdk";

          shellHook = ''
            export PATH=$PATH:${androidPackage}/share/android-sdk/cmdline-tools/latest/bin
            export NDK_HOME="$ANDROID_SDK_ROOT/ndk/$(ls -1 $ANDROID_SDK_ROOT/ndk/)";
          '';
        };
      };
    });
}
