{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vim htop tree ranger nmap telnet mysql redis ];
}