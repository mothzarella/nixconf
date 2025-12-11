{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  fonts.fontconfig.enable = true;
  home.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    noto
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    autoEnable = false;
    image = ./wallpaper.png;

    targets = {
      nixos-icons.enable = true;
      qt.enable = true;
      gtk = {
        enable = true;
        colors.enable = false;
        flatpakSupport.enable = true;
      };

      kitty = {
        colors.enable = false;
        enable = true;
      };

      gnome = {
        enable = true;
        colors.enable = false;
      };
    };

    fonts = with pkgs.nerd-fonts; {
      serif = {
        package = jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      monospace = {
        package = jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        package = noto;
        name = "Noto Nerd Font Color Emoji";
      };
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    cursor = let
      getFrom = url: hash: name: {
        name = name;
        size = 24;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${
            pkgs.fetchzip {
              url = url;
              hash = hash;
            }
          } $out/share/icons/${name}
        '';
      };
    in
      getFrom
      "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.7/Bibata-Modern-Ice.tar.xz"
      "sha256-SG/NQd3K9DHNr9o4m49LJH+UC/a1eROUjrAQDSn3TAU=" "Bibata-Modern-Ice";
  };
}
