pkgs:
with pkgs; {
  packages = [
    go
    go-tools
    delve
  ];

  shellHook = ''
    go version
  '';
}
