pkgs:
with pkgs;
  writeShellScriptBin "ns" ''
    export PATH="${lib.makeBinPath [
      fzf
      pkgs.nix-search-tv
    ]}: $PATH"

    ${builtins.readFile "${nix-search-tv.src}/nixpkgs.sh"}
  ''
