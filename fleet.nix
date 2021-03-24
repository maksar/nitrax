{
  network = {
    description = "Itransition NIXOS fleet";
    enableRollback = true;
    nixpkgs = (import <nixos-20.09-small> { system = "x86_64-linux"; });
  };

  "decepticons" = { config, pkgs, ... }: {
    rootfs = "btrfs";
    imports = [
      ./hardware/efi.nix
      ./os
      ./modules/trimmer.nix
      ./modules/gitman.nix
      ./modules/nine11.nix
      ./modules/ldap-bot.nix
      ./modules/instagram.nix
      ./modules/digest.nix
      ./modules/fukuisima.nix
      ./modules/milestones.nix
      ./modules/personer.nix
    ];

    networking.hostName = "decepticons";
    deployment.targetHost = "decepticons.itransition.corp";
  };
}
