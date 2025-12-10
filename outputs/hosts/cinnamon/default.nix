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
    # desktopManager.gnome.enable = true;
    # gnome = {
    #   core-apps.enable = false;
    #   core-developer-tools.enable = false;
    #   games.enable = false;
    # };
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

  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome
  ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  system.stateVersion = "25.05";
}
