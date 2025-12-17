pkgs:
with pkgs; let
  go = import ./go pkgs;
  terraform = import ./terraform pkgs;
in
  mkShellNoCC {
    packages = go.packages ++ terraform.packages;
    shellHook = ''
      if [ -x "${pkgs.fish}/bin/fish" ]; then
        exec ${pkgs.fish}/bin/fish
      fi

      ${go.shellHook or ""}
      ${terraform.shellHook or ""}
    '';
  }
