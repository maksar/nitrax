{ pkgs, ... }:
let
  nine11 = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/nine11.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ nine11 pkgs.sqlite ];

  deployment.keys.nine11-env = {
    text = builtins.readFile ~/projects/nine11/.env.production;
  };
  systemd.services.nine11 = {
    after = [ "nine11-env-key.service" ];
    wants = [ "nine11-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/nine11-env)
      exec ${nine11}/bin/nine11
    '';
  };
  systemd.timers.nine11 = {
    timerConfig = {
      OnBootSec = "5m";
      OnUnitInactiveSec = "5m";
    };
    wantedBy = [ "timers.target" ];
  };
}
