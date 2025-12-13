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

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # impermanence = {
    #   url = "github:nix-community/impermanence";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

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
        overlays = import ./outputs/overlays {inherit inputs;};

        # accessible through 'nix build', 'nix shell', etc
        devShells = import ./outputs/shells {inherit pkgs;};
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
