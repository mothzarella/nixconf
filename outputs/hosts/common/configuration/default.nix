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
      openssl # secure communication
    ];

    # timezone & i18n
    time.timeZone = mkDefault "Europe/Rome";
    i18n.defaultLocale = mkDefault "en_US.UTF-8";

    # enable privacy kit
    security.polkit.enable = mkDefault true;

    programs = {
      # run unpatched dynamic binaries
      nix-ld.enable = mkDefault true;
    };

    services = {
      # IPC
      dbus.implementation = "broker";

      # user credentials manager
      gnome.gnome-keyring.enable = true;

      # OpenSSH & SSH daemon
      openssh = {
        enable = true;
        allowSFTP = true;
      };

      sshd.enable = true;
    };
  }
