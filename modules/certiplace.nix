{ pkgs, ... }:
let
  certiplace = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/workplace/certificates.git").defaultPackage.${pkgs.system};
  driver = pkgs.unixODBCDrivers.msodbcsql17;
in
{
  environment.systemPackages = [ certiplace driver ];

  deployment.keys.certiplace-env = {
    text = (builtins.readFile ~/projects/certiplace/.env.production) + "\nCERTIPLACE_EMS_DATABASE_DRIVER=${driver}/${driver.driver}";
  };
  systemd.services.certiplace = {
    after = [ "certiplace-env-key.service" ];
    wants = [ "certiplace-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/certiplace-env)
      exec ${certiplace}/bin/certiplace
    '';
  };
  systemd.timers.certiplace = {
    timerConfig = {
      OnCalendar="*-*-01 12:15:00";
    };
    wantedBy = [ "timers.target" ];
  };
}
