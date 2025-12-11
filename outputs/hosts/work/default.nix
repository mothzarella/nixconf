{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # hardware & drivers
    ./hardware.nix
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    # users
    ../common/users/tar

    # local
    ./virtualisation

    # modules
    ../common/audio
    ../common/bluetooth
    ../common/networking
    ../common/printing
    ../common/xdg
  ];

  # bootable system
  boot = {
    extraModprobeConfig = "options kvm_intel nested=1";
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "TIN076";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        5900 # VNC
      ];
    };
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
