{ pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "cinnamon";

  time.timeZone = "Europe/Rome";

  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    nix-ld.enable = true;
    fish.enable = true;
  };

  users.users.tar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [ 
    vim
    gcc
  ];

  system.stateVersion = "25.05";
}
