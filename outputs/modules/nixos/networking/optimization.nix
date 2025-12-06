{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.networking.optimization;
in {
  options.networking.optimization = {
    enable = mkEnableOption ''
      Whether to enable network optimization.
    '';

    congestion = mkOption {
      type = types.enum ["bbr" "cubic" "reno"];
      default = "cubic";
    };

    fastOpen = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # congestion
    {boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = cfg.congestion;}

    # BBR kernel module
    (mkIf (cfg.congestion == "bbr") {
      boot.kernelModules = ["tcp_bbr"];
    })

    # fastOpen
    (mkIf cfg.fastOpen {
      boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 3;
    })
  ]);
}
