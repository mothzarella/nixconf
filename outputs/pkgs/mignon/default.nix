pkgs:
with pkgs;
  stdenvNoCC.mkDerivation rec {
    pname = "mignon-icon-theme";
    src = fetchFromGitHub {
      owner = "igorfmoraes";
      repo = "Mignon-icon-theme";
      rev = "f377ad86b88582aaa0564f559ff2ab296d1d646e";
      hash = "sha256-5Za0HaHjqtUNIa8HX1kUijNv5IKjEm/bxY1lXtrMi0I=";
    };

    dontBuild = true;
    # nativeBuildInputs = [
    #   gtk3
    # ];

    installPhase = ''
      mkdir -p $out/share/icons
      cp -aR $src $out/share/icons/${pname}

      # gtk-update-icon-cache --force $theme
    '';
  }
