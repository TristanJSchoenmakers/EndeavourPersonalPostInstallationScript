{ inputs, config, pkgs, ... }:

let
  secrets = if builtins.pathExists ./secrets.nix
              then import ./secrets.nix
              else {};
in
{
  environment.systemPackages = with pkgs; [
    android-studio
    android-tools
    zulu17
  ];

  programs.nix-ld.enable = true;
  
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = { };

  systemd.services.my_tunnel = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" "systemd-resolved.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=${secrets.cloudflareTunnelToken}";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };
}
