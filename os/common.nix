{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vim htop tree mc ranger ];
}