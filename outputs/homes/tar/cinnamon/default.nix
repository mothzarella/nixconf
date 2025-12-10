{
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ../../common/editors

    self.outputs.homeManagerModules.uwsm
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";

      AQ_TRACE = "1";
      AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    file.".config/uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    packages = with pkgs; [
      ungoogled-chromium

      terraform
    ];
  };

  programs = {
    uwsm.enable = true;
    vesktop.enable = true; # discord alternative

    # terminal
    git.enable = true;
    fastfetch.enable = true;
    btop.enable = true;

    fuzzel.enable = true;
    alacritty.enable = true;
  };
}
