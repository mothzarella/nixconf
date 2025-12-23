{
  lib,
  pkgs ? import <nixpkgs> {},
}:
with pkgs; let
  languages = builtins.listToAttrs (
    map
    (path: {
      name = baseNameOf path;
      value = import path pkgs;
    }) (lib.scanTree {
      type = "directory";
      path = ./languages;
    })
  );
in
  {
    default = mkShellNoCC {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      nativeBuildInputs = [
        nix
        home-manager
        git
      ];
    };

    # development
    # NOTE: this shell contains all development tools from ./languages
    dev = let
      values = builtins.attrValues languages;
      packages = builtins.concatLists (map (lang: lang.packages or []) values);
      shellHook = ''
        ${builtins.concatStringsSep "\n" (map (lang: lang.shellHook or "") values)}

        if [ -x "${pkgs.fish}/bin/fish" ]; then
          exec ${pkgs.fish}/bin/fish
        fi
      '';
    in
      mkShellNoCC {
        inherit packages shellHook;
      };
  }
  # collection of shells for different languages
  # available through `nix develop .#<language_name>`
  // lib.genAttrs (builtins.attrNames languages) (
    lang:
      mkShellNoCC {
        packages = languages.${lang}.packages or [];
        shellHook = ''
          ${languages.${lang}.shellHook or ""}

          if [ -x "${pkgs.fish}/bin/fish" ]; then
            exec ${pkgs.fish}/bin/fish
          fi
        '';
      }
  )
