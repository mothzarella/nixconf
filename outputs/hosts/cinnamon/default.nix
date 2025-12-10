{pkgs, ...}: {
  imports = [
    ./hardware.nix

    # users
    ../common/users/tar

    # local
    ./drivers
    ./virtualisation

    # modules
    ../common/audio
    ../common/bluetooth
    ../common/networking
    ../common/printing
  ];

  # bootable system
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "cinnamon";

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    blueman.enable = true;
    dbus.implementation = "broker";
    gnome = {
      gnome-keyring.enable = true;

      # apps
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };

    # desktopManager.gnome.enable = true;
  };

  programs = {
    uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Scrollable tiling Wayland compositor";
        binPath = "/run/current-system/sw/bin/niri-session";
      };
    };

    niri = {
      enable = true;
      package = pkgs.niri;
    };

    xwayland = {
      enable = true;
      package = pkgs.xwayland-satellite;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome

      # fallback
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr # overlay
    ];
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard # overlay
  ];

  system.stateVersion = "25.05";
}
