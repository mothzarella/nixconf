{...}: {
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

    desktopManager.gnome.enable = true;
  };

  system.stateVersion = "25.05";
}
