{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # wayland pkgs
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # audio
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # FIX: update substituters
  #  nixConfig = {
  #    substituters = [
  #      "https://cache.nixos.org"
  #      "https://nix-community.cachix.org"
  #
  #      # extra substituters
  #      "https://devenv.cachix.org"
  #      "https://nixpkgs-wayland.cachix.org"
  #    ];
  #    trusted-public-keys = [
  #      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  #
  #      # extra keys
  #      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
  #      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  #    ];
  #  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    lib = nixpkgs.lib.extend (
      _final: _prev:
        (import ./lib inputs) // home-manager.lib
    );
  in
    with lib;
      eachSystem [
        "x86_64-linux" # linux & WSL
      ] (system: let
        pkgs = pkgsFor system;
      in {
        # formatter (alejandra, nixfmt, treefmt-nix or nixpkgs-fmt)
        formatter = pkgs.alejandra;

        # overlay, consumed by other flakes
        overlays = import ./outputs/overlays;

        # accessible through 'nix build', 'nix shell', etc
        devShells = import ./outputs/shell.nix {inherit pkgs;};
        packages = import ./outputs/pkgs {inherit pkgs;};
      })
      // {
        inherit lib;

        # NixOS configuration entrypoint
        # available through `sudo nixos-rebuld --flake ~/nix#hostname`
        nixosConfigurations = {
          # WSL
          "aurora" = nixosSystem {
            specialArgs = {inherit inputs self;};
            modules = [
              ./outputs/hosts/common
              ./outputs/hosts/aurora
            ];
          };

          # personal laptop
          # NOTE: `cinnamon` is pretty much the same as
          # `work` but with some gaming stuff
          "cinnamon" = nixosSystem {
            specialArgs = {inherit inputs self;};
            modules = [
              ./outputs/hosts/common/configuration
              ./outputs/hosts/cinnamon
            ];
          };

          # work laptop
          "TIN076" = nixosSystem {
            specialArgs = {inherit inputs self;};
            modules = [
              ./outputs/hosts/common/configuration
              ./outputs/hosts/work
            ];
          };
        };

        # standalone home-manager configuration entrypoint
        # available through `home-manager --flake .#username@hostname`
        homeConfigurations = {
          "tar@cinnamon" = homeManagerConfiguration {
            pkgs = pkgsFor "x86_64-linux";
            extraSpecialArgs = {inherit inputs self;};
            modules = [
              ./outputs/homes/tar/cinnamon
              ./outputs/homes/common
            ];
          };

          "tar@TIN076" = homeManagerConfiguration {
            pkgs = pkgsFor "x86_64-linux";
            extraSpecialArgs = {inherit inputs self;};
            modules = [
              ./outputs/homes/tar/work
              ./outputs/homes/common
            ];
          };
        };

        # reusable nixos & home-manager modules
        nixosModules = import ./outputs/modules/nixos;
        homeManagerModules = import ./outputs/modules/home-manager;
      };
}
