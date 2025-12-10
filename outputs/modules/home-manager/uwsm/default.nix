{
  config,
  lib,
  ...
}: let
  cfg = config.programs.uwsm;
in
  with lib; {
    options.programs.uwsm = {
      enable = mkEnableOption ''
        Whether to enable UWSM.
      '';

      desktop = mkOption {
        type = types.str;
        default = "auto";
        description = ''
          Desktop environment name for XDG variables, or 'auto' to use preset variables
        '';
        example = "Hyprland";
      };

      nvidia = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable NVIDIA-specific variables
        '';
      };
    };

    config = mkIf cfg.enable {
      home = {
        sessionVariables = mkMerge [
          {
            NIXOS_OZONE_WL = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            GDK_BACKEND = "wayland,x11,*";
            QT_QPA_PLATFORM = "wayland;xcb";
            SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
            XDG_SESSION_TYPE = "wayland";
          }

          # desktop
          (
            mkIf (cfg.desktop != "auto") {
              XDG_CURRENT_DESKTOP = cfg.desktop;
              XDG_SESSION_DESKTOP = cfg.desktop;
            }
          )

          # nvidia
          (
            mkIf cfg.nvidia {
              GBM_BACKEND = "nvidia-drm";
              __GLX_VENDOR_LIBRARY_NAME = "nvidia";
              __GL_GSYNC_ALLOWED = "1";
              __GL_VRR_ALLOWED = "0";
              LIBVA_DRIVER_NAME = "nvidia";
              NVD_BACKEND = "direct";
            }
          )
        ];

        # apply session vars
        file.".config/uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      };
    };
  }
