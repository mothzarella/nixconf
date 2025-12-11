{pkgs, ...}: {
  programs = {
    neovim.enable = true;
    zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "terraform"
        "colored-zed-icons-theme"
        "qml"
      ];

      userSettings = {
        vim_mode = true;
        icon_theme = "Colored Zed Icons Theme Dark";
        theme = {
          mode = "system";
          dark = "One Dark";
          light = "One Light";
        };

        agent = {
          enabled = true;
          default_model = {
            provider = "copilot_chat";
            model = "gpt-4.1";
          };
        };

        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter.external.command = "${pkgs.alejandra}/bin/alejandra";
          };
        };

        lsp = {
          # nix
          nil.binary.path = "${pkgs.nil}/bin/nil";

          # terraform
          terraform-ls.binary.path = "${pkgs.terraform-ls}/bin/terraform-ls";
        };
      };
    };
  };
}
