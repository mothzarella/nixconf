{lib, ...}:
with lib; {
  # bluetooth device GUI
  services.blueman.enable = mkDefault true;

  hardware.bluetooth = {
    enable = mkDefault true;
    powerOnBoot = mkDefault true;
    settings = {
      General = {
        # shows battery charge of connected devices
        Experimental = mkDefault true;

        # faster connection
        FastConnectable = mkDefault true;
      };
      Policy = {
        # enable all controllers when they are found.
        AutoEnable = mkDefault true;
      };
    };
  };
}
