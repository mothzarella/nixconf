pkgs:
with pkgs; {
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
