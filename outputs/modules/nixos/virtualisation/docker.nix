{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.virtualisation;
in
  with lib; {
    options.virtualisation.docker = {
      compose.enable = mkEnableOption ''
        Whether to enable DockerCompose.
      '';
    };

    config = mkIf (cfg.docker.enable && cfg.docker.compose.enable) {
      environment.systemPackages = with pkgs; [docker-compose];
    };
  }
