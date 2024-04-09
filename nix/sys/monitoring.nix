{ config, lib, pkgs, ... }:
let
  cfg = config.matthias.monitoring;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.matthias.monitoring = {
    enable = mkEnableOption "monitoring";
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings.server = {
        domain = "grafana.karl";
        http_port = 2342;
        http_addr = "0.0.0.0";
      };
    };

    services.prometheus = {
      enable = true;
      port = 9001;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "systemd" ];
          port = 9002;
        };
      };
      scrapeConfigs = [
        {
          job_name = "router-node";
          static_configs = [{
            targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
          }];
        }
      ];
    };

  #services.loki = {
  #  enable = true;
  #  configFile = "./configs/loki-local.config.yaml";
  #};

    services.nginx.virtualHosts.${config.services.grafana.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proyWebsockets = true;
      };
    };
  };
}
