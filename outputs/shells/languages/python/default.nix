pkgs:
with pkgs; {
  packages = with pkgs; [
    ruff

    python313Packages.uv
    python313Packages.pip
  ];

  shellHook = ''
    python --version
  '';
}
