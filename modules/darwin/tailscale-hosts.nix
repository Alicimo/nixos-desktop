{ pkgs, ... }:
let
  updateTailscaleHosts = pkgs.writeShellScript "update-tailscale-hosts" ''
    exec ${pkgs.python3}/bin/python3 ${../../scripts/update_tailscale_hosts.py} --write
  '';
in
{
  launchd.daemons.tailscale-hosts = {
    script = ''
      exec ${updateTailscaleHosts}
    '';

    serviceConfig = {
      RunAtLoad = true;
      StartInterval = 300;
      KeepAlive = false;
      StandardOutPath = "/var/log/tailscale-hosts.log";
      StandardErrorPath = "/var/log/tailscale-hosts.log";
    };
  };
}
