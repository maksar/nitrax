{ pkgs, ... }:
let
  digest = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/projcard/digest.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ digest ];

  deployment.keys.digest-env = {
    text = builtins.readFile ~/projects/digest/.env.production;
  };
  systemd.services.digest = {
    after = [ "digest-env-key.service" ];
    wants = [ "digest-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/digest-env)
      exec ${digest}/bin/digest --update --render --send
    '';
  };
  systemd.timers.digest = {
    timerConfig = {
      OnCalendar = "*-*-10,25 08:30";
    };
    wantedBy = [ "timers.target" ];
  };
}
