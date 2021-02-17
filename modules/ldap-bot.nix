{ pkgs, ... }:
let
  ldap-bot = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/ldap-bot.git").packages.${pkgs.system}.facebook;
in
{
  environment.systemPackages = [ ldap-bot ];

  deployment.keys.ldap-bot-env = {
    text = builtins.readFile ~/projects/ldap-bot/.env.production;
  };
  systemd.services.ldap-bot = {
    after = [ "ldap-bot-env-key.service" ];
    wants = [ "ldap-bot-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/ldap-bot-env)
      exec ${ldap-bot}/bin/ldap-bot-facebook
    '';
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
    };
  };

  deployment.keys.ldap-bot-qa-env = {
    text = builtins.readFile ~/projects/ldap-bot/.env.qa.production;
  };
  systemd.services.ldap-bot-qa = {
    after = [ "ldap-bot-qa-env-key.service" ];
    wants = [ "ldap-bot-qa-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/ldap-bot-qa-env)
      exec ${ldap-bot}/bin/ldap-bot-facebook
    '';
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
    };
  };

  networking.firewall.allowedTCPPorts = [31337 31338];
}
