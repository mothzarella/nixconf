{pkgs, ...}: {
  imports = [
    ../../common/editors
  ];

  home.packages = with pkgs; [
    terraform
  ];

  programs = {
    git.enable = true;
    vesktop.enable = true;
  };
}
