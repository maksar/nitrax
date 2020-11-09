{ pkgs, ... }:
let
  trimmer = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/trimmer.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ trimmer ];

  deployment.keys.trimmer-env = {
    text = builtins.readFile ~/projects/trimmer/.env.production;
  };
  systemd.services.trimmer = {
    after = [ "trimmer-env-key.service" ];
    wants = [ "trimmer-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/trimmer-env)
      exec ${trimmer}/bin/trimmer
    '';
  };
  systemd.timers.trimmer = {
    timerConfig = {
      OnBootSec = "1h";
      OnUnitInactiveSec = "1h";
    };
    wantedBy = [ "timers.target" ];
  };
}
