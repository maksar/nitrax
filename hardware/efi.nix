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
      gatewayPorts = "yes";
    };

    users.users.root.openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCorap2ULKQnTkhSY9EinQIB3tJlq9Xp+GNZpJGOQa6fJqCQccr+9+lPBtcjx9pSfIuwPf+iRZi69pG7KfzfsTg0UB4Wi8zZ6D4jOpQp12qGLAZIJ2XgbNLZ+KW5ZBAmROoo/sdppl8cIPfx1yiEbt3fH5t95b81p6waPORt4NOOje4Rjskw0Cr76EmiIEROoURo6i4Z2eI1uUubO4zwjVJqDKGTaCjIBglBYJI7b53J7zz1RI9INtqZO0Jtn7OnQDdINMkOCSVlsQ9GE89uI6PidCrOCqyk/oLouvQmqWIMBVdhGJR6cXg7zzDr+dS8U37O9vuvVUvkcaLNF94YMKT Linux.Administrators@itransition.com" ];
  };

  options = {
    rootfs = lib.mkOption {
      type = lib.types.str;
      description = "file system for the root partition";
      default = "ext4";
    };
  };
}
