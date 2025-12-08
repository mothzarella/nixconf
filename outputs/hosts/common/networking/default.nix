{
  lib,
  self,
  ...
}:
with lib; {
  imports = [
    self.outputs.nixosModules.networking
  ];

  networking = {
    dns.enable = mkDefault true;

    optimization = {
      enable = mkDefault true;
      congestion = mkDefault "bbr";
    };

    networkmanager = {
      enable = mkDefault true;
      wifi.powersave = mkDefault true;
    };
  };
}
