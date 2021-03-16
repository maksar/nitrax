{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  boot.initrd.availableKernelModules = [ "ata_piix" "vmw_pvscsi" "sd_mod" "sr_mod" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.timeout = 1;

  networking.useDHCP = true;
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    gatewayPorts = "yes";
  };
}
