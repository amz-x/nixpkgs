{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.proton-vpn;

  # Values of NetworkManager's connection.dns-over-tls property.
  dnsOverTlsValues = {
    no = 0;
    opportunistic = 1;
    yes = 2;
  };
in
{
  options.services.proton-vpn = {
    enable = mkEnableOption "the Proton VPN desktop app";

    package = mkPackageOption pkgs "proton-vpn" { };

    splitTunneling = {
      enable = mkEnableOption "the split tunneling daemon used by the Proton VPN app" // {
        default = true;
      };

      package = mkPackageOption pkgs [ "python3Packages" "proton-vpn-daemon" ] { };
    };

    interface = mkOption {
      type = types.str;
      default = "proton0";
      description = "Name of the network interface the Proton VPN app creates for the tunnel.";
    };

    tunnelDnsOverTls = mkOption {
      type = types.nullOr (types.enum (lib.attrNames dnsOverTlsValues));
      default = "no";
      description = ''
        DNS over TLS mode NetworkManager requests from systemd-resolved for the VPN interface,
        or `null` to inherit the global setting.

        Proton's in-tunnel resolver does not offer DNS over TLS, so a strict global
        {option}`services.resolved.settings.Resolve.DNSOverTLS` would otherwise break name
        resolution while connected. Queries to it are already encrypted by the tunnel.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = config.networking.networkmanager.enable;
          message = "services.proton-vpn requires networking.networkmanager.enable, as the app manages its connections through NetworkManager.";
        }
      ];

      environment.systemPackages = [ cfg.package ];

      networking.networkmanager.settings = mkIf (cfg.tunnelDnsOverTls != null) {
        "connection-proton-vpn" = {
          match-device = "interface-name:${cfg.interface}";
          "connection.dns-over-tls" = dnsOverTlsValues.${cfg.tunnelDnsOverTls};
        };
      };
    }

    (mkIf cfg.splitTunneling.enable {
      # bcc compiles the daemon's eBPF programs at runtime against the kernel headers,
      # which it unpacks from /sys/kernel/kheaders.tar.xz.
      boot.kernelModules = [ "kheaders" ];

      services.dbus.packages = [ cfg.splitTunneling.package ];
      systemd.packages = [ cfg.splitTunneling.package ];

      systemd.services."me.proton.vpn.split_tunneling" = {
        # The app only offers split tunneling while the daemon is already running on the
        # system bus, D-Bus activation is not enough.
        wantedBy = [ "multi-user.target" ];
        # bcc shells out to tar/xz to unpack the kernel headers and to modprobe to load them.
        path = with pkgs; [
          gnutar
          kmod
          xz
        ];
      };
    })
  ]);

  meta.maintainers = with lib.maintainers; [ amz-x ];
}
