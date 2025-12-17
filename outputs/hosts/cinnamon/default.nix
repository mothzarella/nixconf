{pkgs, ...}: {
  imports = [
    # hardware & drivers
    ./hardware.nix
    ./drivers

    # users
    ../common/users/tar

    # local
    ./virtualisation

    # modules
    ../common/audio
    ../common/bluetooth
    ../common/networking
    ../common/portals
    ../common/printing
  ];

  # bootable system
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "cinnamon";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5900 # VNC
      ];
    };
  };

  services = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # multi-touch gesture recognizer
    touchegg.enable = false;

    # allows applications to update firmware
    fwupd.enable = true;

    # temperature management
    thermald.enable = true;

    # userspace virtual filesystem
    gvfs.enable = true;
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

  environment.systemPackages = with pkgs; [
    wl-clipboard # overlay
  ];

  system.stateVersion = "25.05";
}
