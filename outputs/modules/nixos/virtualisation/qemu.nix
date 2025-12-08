{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.virtualisation.qemu;
in
  with lib; {
    options.virtualisation = {
      libvirtd.members = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of users to add to libvirtd group.
        '';
      };

      qemu = {
        enable = mkEnableOption ''
          QEMU/KVM virtualization.
        '';

        virtManager = {
          enable = mkEnableOption ''
            Virt Manager GUI.
          '';
        };
      };
    };

    config = mkIf cfg.enable (mkMerge [
      # qemu
      {
        virtualisation.spiceUSBRedirection.enable = true;

        services = {
          qemuGuest.enable = mkDefault true;
          spice-vdagentd.enable = mkDefault true;
        };
      }

      # libvirt daemon
      (mkIf config.virtualisation.libvirtd.enable {
        users.groups.libvirtd.members = config.virtualisation.libvirtd.members;

        virtualisation.libvirtd.qemu = {
          runAsRoot = mkDefault true;
          swtpm.enable = mkDefault true;
        };
      })

      # virt-manager
      (mkIf cfg.virtManager.enable (mkMerge [
        {
          programs.virt-manager.enable = mkDefault true;

          environment.systemPackages = with pkgs; [
            virt-manager
            virt-viewer
            spice
            spice-gtk
            spice-protocol
          ];
        }

        # file (in the menu bar) -> Add connection
        # hyperVisor = QEMU/KVM
        # autoconnect = checkmark
        # connect
        (mkIf config.programs.dconf.enable {
          programs.dconf.profiles = {
            user.databases = [
              {
                settings = {
                  "org/virt-manager/virt-manager/connections" = {
                    autoconnect = ["qemu:///system"];
                    uris = ["qemu:///system"];
                  };
                };
              }
            ];
          };
        })
      ]))

      {
        warnings =
          if (config.virtualisation.libvirtd.enable && config.virtualisation.libvirtd.members == [])
          then [
            ''
              `virtualisation.libvirtd` is enabled but no members are defined.
              Add users to `virtualisation.libvirtd.members` to grant access.
            ''
          ]
          else [];
      }
    ]);
  }
