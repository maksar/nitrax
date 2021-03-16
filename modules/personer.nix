{ pkgs, ... }:
let
  personer = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/personer.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ personer ];

  deployment.keys.personer-env = {
    text = builtins.readFile ~/projects/personer/.env.production;
  };
  systemd.services.personer = {
    after = [ "personer-env-key.service" ];
    wants = [ "personer-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/personer-env)
      exec ${personer}/bin/personer
    '';
  };
  systemd.timers.personer = {
    timerConfig = {
      OnBootSec = "1h";
      OnUnitInactiveSec = "1h";
    };
    wantedBy = [ "timers.target" ];
  };
}
