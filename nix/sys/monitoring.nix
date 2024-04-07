{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    domain = "grafana.karl";
    port = 2342;
    addr = "127.0.0.1";
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
      snmp = {
        enable = true;
        port = 9003;
      };
    };
    scrapeConfigs = [
      {
        job_name = "router-node";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        }];
      }
      {
        job_name = "router-snmp";
        static_configs = [{
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.snmp.port}" ];
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

}
