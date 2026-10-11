{
  description = "Nix package, flake, and Home Manager module for FrankenTerm (ft) - swarm-native terminal platform for AI agent fleets";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in rec {
          default = frankenterm;
          frankenterm = pkgs.callPackage ./package.nix { };
          ft = frankenterm;
        }
      );

      overlays.default = final: prev: {
        frankenterm = self.packages.${prev.stdenv.hostPlatform.system}.frankenterm;
        ft = self.packages.${prev.stdenv.hostPlatform.system}.frankenterm;
      };

      homeManagerModules = {
        default = self.homeManagerModules.frankenterm;
        frankenterm = import ./modules/home-manager.nix self;
      };
    };
}
