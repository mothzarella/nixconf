pkgs:
with pkgs;
  stdenvNoCC.mkDerivation rec {
    pname = "silent";
    version = "1.3.5";
    src = fetchFromGitHub {
      owner = "uiriansan";
      repo = "SilentSDDM";
      rev = "v${version}";
      sha256 = "sha256-R0rvblJstTgwKxNqJQJaXN9fgksXFjPH5BYVMXdLsbU=";
    };
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/${pname}
    '';
  }
