{ pkgs, ... }:
let
  coorish = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/coorish.git").packages.${pkgs.system};
in
{
  environment.systemPackages = builtins.attrValues coorish;

  deployment.keys.coorish-env = {
    text = builtins.readFile ~/projects/coorish/.env.production;
  };
  systemd.services = builtins.mapAttrs (name: value: {
    after = [ "coorish-env-key.service" ];
    wants = [ "coorish-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/coorish-env)
      exec ${value}/bin/coorish
    '';
  }) coorish;

  systemd.timers = builtins.mapAttrs (name: value: {
    timerConfig = {
      OnCalendar="*-*-* 10:00:00";
    };
    wantedBy = [ "timers.target" ];
  }) coorish;
}
