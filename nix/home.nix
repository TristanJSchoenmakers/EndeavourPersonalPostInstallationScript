{ inputs, config, pkgs, ... }:

let
  secrets = if builtins.pathExists ./secrets.nix
              then import ./secrets.nix
              else {};
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  };

  environment.systemPackages = with pkgs; [
    discord
  ];
}
