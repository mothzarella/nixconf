{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
  with lib; {
    imports = [
      ./maintenance.nix
    ];

    # NixOS settings & features
    nix = {
      settings = {
        experimental-features = mkDefault "nix-command flakes";
        flake-registry = mkDefault "";
        nix-path = mkDefault config.nix.nixPath;
      };

      channel.enable = mkDefault false;
      registry = mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

    # system packages
    environment.systemPackages = with pkgs; [
      vim # must have editor
      clang # LLVM
      git # version control
    ];

    # run unpatched dynamic binaries
    programs.nix-ld.enable = true;

    # timezone & i18n
    time.timeZone = mkDefault "Europe/Rome";
    i18n.defaultLocale = mkDefault "en_US.UTF-8";

    # privacy kit
    security.polkit.enable = mkDefault true;

    # enable cpu printing
    services.printing.enable = mkDefault true;
  }
