{ pkgs, ... }:
let
  milestones = (builtins.getFlake "git+ssh://git@git.itransition.com:7999/ia/milestones.git").defaultPackage.${pkgs.system};
in
{
  environment.systemPackages = [ milestones ];

  deployment.keys.milestones-env = {
    text = builtins.readFile ~/projects/milestones/.env.production;
  };
  systemd.services.milestones = {
    after = [ "milestones-env-key.service" ];
    wants = [ "milestones-env-key.service" ];
    script = ''
      source <(sed -E 's/([A-Z_0-9]+)=(.*)/export \1=\2/g' /run/keys/milestones-env)
      exec ${milestones}/bin/milestones
    '';
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Restart = "always";
    };
  };

  networking.firewall.allowedTCPPorts = [ 7878 ];
}
