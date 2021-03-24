{ pkgs, ... }:
let
  gitman = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/gitman.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ gitman ];

  deployment.keys.gitman-env = {
    text = builtins.readFile ~/projects/gitman/.env.production;
  };
  deployment.keys."users.yml" = {
    text = builtins.readFile ~/projects/gitman/config/users.yml;
    destDir = "/root/.gitman";
  };
  deployment.keys."git.cer" = {
    text = builtins.readFile ~/projects/gitman/config/git.cer;
    destDir = "/root/.gitman";
  };
  deployment.keys."ldap.cer" = {
    text = builtins.readFile ~/projects/gitman/config/ldap.cer;
    destDir = "/root/.gitman";
  };
  systemd.services.gitman = {
    after = [ "gitman-env-key.service" "users.yml-key.service" "git.cer-key.service" "ldap.cer-key.service" ];
    wants = [ "gitman-env-key.service" "users.yml-key.service" "git.cer-key.service" "ldap.cer-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/gitman-env)
      exec ${gitman}/bin/gitman
    '';
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = 5;
    };
    unitConfig = {
      StartLimitBurst = 1440;
      StartLimitIntervalSec = 7200;
    };
  };
}
