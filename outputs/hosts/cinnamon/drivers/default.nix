{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hardware.nvidia.package;
in {
  imports = with inputs.hardware.nixosModules; [
    common-pc-laptop-ssd
    common-cpu-intel-cpu-only
    common-gpu-nvidia-sync
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

  hardware = {
    # enable OpenGL
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapi-intel-hybrid
        nvidia-vaapi-driver
        libva
      ];
    };
    nvidia = {
      # enable the open source drivers if the package supports it
      open = cfg ? open && cfg ? firmware;

      # prevent suspend/wakeup issues
      powerManagement.enable = true;

      # prime sync pci
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # kernel driver package
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
