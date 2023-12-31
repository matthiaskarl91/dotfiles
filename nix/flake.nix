{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, nixos-hardware }@inputs:
    let
      inherit (nix-darwin.lib) darwinSystem;
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages."${system}";
      linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;
      darwin-builder = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [
          "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
          {
            virtualisation.host.pkgs = pkgs;
            system.nixos.revision = nixpkgs.lib.mkForce null;
          }
        ];
      };
    in
    {
      darwinConfigurations."Matthiascmdscale" = nix-darwin.lib.darwinSystem {
        #you can have multiple darwinConfigurations per flake, one per hostname
        inherit system;
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/matthias/default.nix
          {
            nix.distributedBuilds = true;
            nix.buildMachines = [{
              hostName = "ssh://builder@localhost";
              system = linuxSystem;
              maxJobs = 4;
              supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
            }];

            launchd.daemons.darwin-builder = {
              command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
              serviceConfig = {
                KeepAlive = true;
                RunAtLoad = true;
                StandardOutPath = "/var/log/darwin-builder.log";
                StandardErrorPath = "/var/log/darwin-builder.log";
              };
            };
          }
        ]; # will be important later
      };
      images = {
        pi = (self.nixosConfigurations.pi.extendModules {
          modules = [ "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix" ];
        }).config.system.build.sdImage;
      };
      nixosConfigurations = {
        vmlinux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/vmlinux/base.nix
            ./hosts/vmlinux/vm.nix
          ];
        };
        packages.x86_64-linux.linuxVM = self.nixosConfigurations.vmlinux.config.system.build.vm;
        pi = nixpkgs.lib.nixosSystem {
          system = "armv7";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-2
            ./hosts/pi/configuration.nix
            ./hosts/pi/base.nix
          ];
        };
      };
    };
}
