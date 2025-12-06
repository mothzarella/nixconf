{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.networking.dns;
in {
  options.networking.dns = {
    enable = mkEnableOption ''
      Whether to enable network optimization.
    '';

    manual = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable && cfg.manual) {
    networking = {
      networkmanager.dns = mkForce "none";
      useDHCP = mkForce false;
      dhcpcd.enable = mkForce false;
    };

    assertions = [
      {
        assertion = cfg.manual -> (config.networking.nameservers != []);
        message = ''
          Manually configure DNS servers when NetworkManager's internal DNS resolution is disabled
        '';
      }
    ];
  };
}
