{ config, lib, ... }:
{
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOTFS";
      fsType = config.rootfs;
    };
    boot.initrd.availableKernelModules = [ "ata_piix" "vmw_pvscsi" "sd_mod" "sr_mod" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.timeout = 1;

    virtualisation.vmware.guest.enable = true;

    time.timeZone = "Europe/Minsk";

    networking.useDHCP = true;
    services.openssh = {
      enable = true;
      permitRootLogin = "yes";
    };
  };

  options = {
    rootfs = lib.mkOption {
      type = lib.types.str;
      description = "file system for the root partition";
      default = "ext4";
    };
  };
}
