{ pkgs, ... }:
let
  fukuisima = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/fukuisima.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ fukuisima ];

  deployment.keys.fukuisima-env = {
    text = builtins.readFile ~/projects/fukuisima/.env.production;
  };

  systemd.services.fukuisima-report = {
    after = [ "fukuisima-env-key.service" ];
    wants = [ "fukuisima-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/fukuisima-env)
      exec ${fukuisima}/bin/fukuisima report -s
    '';
  };
  systemd.timers.fukuisima-report = {
    timerConfig = {
      OnCalendar = "*-*-* 09:00";
    };
    wantedBy = [ "timers.target" ];
  };

  systemd.services.fukuisima-notify = {
    after = [ "fukuisima-env-key.service" ];
    wants = [ "fukuisima-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/fukuisima-env)
      exec ${fukuisima}/bin/fukuisima notify -s
    '';
  };
  systemd.timers.fukuisima-notify = {
    timerConfig = {
      OnCalendar = "*-*-* 09:10";
    };
    wantedBy = [ "timers.target" ];
  };

}
