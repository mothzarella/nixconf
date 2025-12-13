pkgs:
with pkgs;
  mkShellNoCC {
    packages = [
      terraform
      terraform-ls
      tflint
      terragrunt
      terraformer
    ];

    shellHook = ''
      terraform version
    '';
  }
