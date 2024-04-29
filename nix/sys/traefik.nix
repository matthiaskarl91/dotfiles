{ config, lib, pkgs, ... }:
let
  cfg = config.matthias.traefik;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.matthias.traefik = {
    enable = mkEnableOption "traefik reverse proxy";
  };

  config = mkIf cfg.enable {
    services.traefik = {
      enable = true;
      dynamicConfigOptions = {
        http = {
          routers = {
            grafanaRouter = {
              rule = "Host(`monitoring.router.home`)";
              service = "grafana";
            };
            homeAssistantRouter = {
              rule = "Host(`automation.router.home`)";
              service = "homeAssistant";
            };
          };
          services = {
            grafana = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:2342";
                  }
                ];
              };
            };
            homeAssistant = {
              loadBalancer = {
                servers = [
                  {
                    url = "http://localhost:8123";
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}
