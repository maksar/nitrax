{
  network = {
    description = "Itransition NIXOS fleet";
    enableRollback = true;
    nixpkgs = (builtins.getFlake "github:NixOS/nixpkgs/release-20.03").legacyPackages."x86_64-linux";
  };

  "nixos-srv-01" =
    { config, pkgs, ... }:
    {
      imports = [ ./hardware/grub.nix ./os ];

      networking.hostName = "nixos-srv-01";
      deployment.targetHost = "nixos-srv-01.itransition.corp";
    };

  "decepticons" =
    { config, pkgs, ... }:
    {
      rootfs = "btrfs";
      imports = [ ./hardware/efi.nix ./os ./modules/trimmer.nix ./modules/gitman.nix ./modules/nine11.nix ./modules/ldap-bot.nix ./modules/instagram.nix ];

      networking.hostName = "decepticons";
      deployment.targetHost = "decepticons.itransition.corp";
    };

  "nixos-srv-02" =
    { config, pkgs, ... }:
    {
      imports = [ ./hardware/efi.nix ./os ];

      networking.hostName = "nixos-srv-02";
      deployment.targetHost = "nixos-srv-02.itransition.corp";
    };
}
