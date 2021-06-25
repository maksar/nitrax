{ pkgs, ... }:
let
  fukuisima = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/fukuisima.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ fukuisima ];

  deployment.keys.fukuisima-env = {
    text = builtins.readFile ~/projects/fukuisima/.env.production;
  };
  deployment.keys."fukuisima-ldap.cer" = {
    text = builtins.readFile ~/projects/fukuisima/config/ldap.cer;
    destDir = "/root/.fukuisima";
  };

  systemd.services.fukuisima-report = {
    enable = false;
    after = [ "fukuisima-env-key.service" "fukuisima-ldap.cer-key.service" ];
    wants = [ "fukuisima-env-key.service" "fukuisima-ldap.cer-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/fukuisima-env)
      exec ${fukuisima}/bin/fukuisima report -s
    '';
  };
  systemd.timers.fukuisima-report = {
    enable = false;
    timerConfig = {
      OnCalendar = "Mon..Fri *-*-* 09:00";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services.fukuisima-notify = {
    enable = false;
    after = [ "fukuisima-env-key.service" "fukuisima-ldap.cer-key.service" ];
    wants = [ "fukuisima-env-key.service" "fukuisima-ldap.cer-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/fukuisima-env)
      exec ${fukuisima}/bin/fukuisima notify -s
    '';
  };
  systemd.timers.fukuisima-notify = {
    enable = false;
    timerConfig = {
      OnCalendar = "Mon..Fri *-*-* 09:10";
    };
    wantedBy = [ "timers.target" ];
  };

}
