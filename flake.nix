# Maintainer: Dorian Luyet (@DurianTheWAV), with linux/nix/package.nix.
{
  description = "Mercury: Mochi lives at the top of your screen and keeps an eye on your AI coding agents";

  # Try it:          nix run github:allanindrajith/Mercury
  # On NixOS, add the flake to your inputs, then:
  #   environment.systemPackages = [ inputs.mercury.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  # Through the overlay instead, allow it in your own nixpkgs config, since the
  # artwork is not free (see meta.license in linux/nix/package.nix):
  #   nixpkgs.overlays = [ inputs.mercury.overlays.default ];
  #   nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "mercury";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              # Only for this package: building it for yourself is what its
              # license allows.
              config.allowUnfreePredicate = pkg: lib.getName pkg == "mercury";
            }
          )
        );
    in
    {
      packages = forAllSystems (pkgs: {
        mercury = pkgs.callPackage ./linux/nix/package.nix { };
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.mercury;
      });

      overlays.default = final: prev: {
        mercury = final.callPackage ./linux/nix/package.nix { };
      };

      # The toolchain and libraries to work on the Linux app: `nix develop`, then
      # `cd windows && npm ci && npm run tauri dev`.
      devShells = forAllSystems (
        pkgs:
        let
          mercury = self.packages.${pkgs.stdenv.hostPlatform.system}.mercury;
        in
        {
          default = pkgs.mkShell {
            inputsFrom = [ mercury ];
            SHERPA_ONNX_LIB_DIR = "${mercury.sherpaOnnxStatic}/lib";
          };
        }
      );

      formatter = forAllSystems (pkgs: pkgs.nixfmt);
    };
}
