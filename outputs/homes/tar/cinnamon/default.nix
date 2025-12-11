{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../common/editors

    ./niri
    ./theme
  ];

  home = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";

      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0";
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };

    file.".config/uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

    packages = with pkgs; [
      libnotify

      ungoogled-chromium
      nautilus
      nix-search

      terraform
    ];
  };

  services = {
    mako = {
      enable = true;
      settings = {
        actions = true;
        anchor = "top-right";
        icons = true;
      };
    };
  };

  programs = {
    vesktop.enable = true; # discord alternative

    # terminal
    fastfetch.enable = true;
    btop.enable = true;

    fuzzel.enable = true;
    kitty.enable = true;
  };
}
