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
  deployment.keys."dc1.cer" = {
    text = builtins.readFile ~/projects/gitman/config/dc1.cer;
    destDir = "/root/.gitman";
  };
  systemd.services.gitman = {
    after = [ "gitman-env-key.service" "users.yml-key.service" "git.cer-key.service" "dc1.cer-key.service" ];
    wants = [ "gitman-env-key.service" "users.yml-key.service" "git.cer-key.service" "dc1.cer-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/gitman-env)
      exec ${gitman}/bin/gitman
    '';
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
    };
  };
}
