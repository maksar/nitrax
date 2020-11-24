{ pkgs, ... }:
let
  instagram = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/workplace/instagram.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ instagram ];

  deployment.keys.instagram-env = {
    text = builtins.readFile ~/projects/instagram/.env.production;
  };
  systemd.services.instagram = {
    after = [ "instagram-env-key.service" ];
    wants = [ "instagram-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/instagram-env)
      exec ${instagram}/bin/instagram
    '';
  };
  systemd.timers.instagram = {
    timerConfig = {
      OnBootSec = "1d";
      OnUnitInactiveSec = "1d";
    };
    wantedBy = [ "timers.target" ];
  };
}
