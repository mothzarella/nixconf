pkgs:
with pkgs;
  mkShellNoCC {
    packages = [
      go
      go-tools
      delve
      gomodifytags
      impl
    ];

    shellHook = ''
      export GOPATH=$PWD/.go
      export PATH=$GOPATH/bin: $PATH
      go version
    '';
  }
