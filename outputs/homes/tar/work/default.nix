{pkgs, ...}: {
  imports = [
    ../. # base configuration

    ../../common/editors

    ./niri
    ./theme
  ];

  home = {
    packages = with pkgs; [
      terraformer
    ];
  };
}
