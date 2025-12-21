pkgs:
with pkgs; let
  go = import ./go pkgs;
  terraform = import ./terraform pkgs;
  python = import ./python pkgs;
in
  mkShellNoCC {
    packages =
      [
        wrk
      ]
      ++ go.packages
      ++ terraform.packages
      ++ python.packages;

    shellHook = ''
      if [ -x "${pkgs.fish}/bin/fish" ]; then
        exec ${pkgs.fish}/bin/fish
      fi

      ${go.shellHook or ""}
      ${terraform.shellHook or ""}
      ${python.shellHook or ""}
    '';
  }
