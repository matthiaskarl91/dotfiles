{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, nixos-hardware, agenix }@inputs:
    let
      matthias = { inherit nixpkgs; };
      inherit (nix-darwin.lib) darwinSystem;
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages."${system}";
      linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;
      darwin-builder = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
          ./home/darwin/skhd.nix
          ./home/darwin/yabai.nix
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.${system}.default ];
          }
        ];
      };
      images = {
        pi = (self.nixosConfigurations.pi.extendModules {
          modules = [ "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform.nix" ];
        }).config.system.build.sdImage;
      };
      nixosConfigurations = {
        router = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit agenix;
          };
          modules = [
            {
              nixpkgs.overlays = [
                (self: super: {
                  linuxPackages_latest = super.linuxPackages_latest.extend (lpself: lpsuper: {
                    ath10k = super.linuxPackages_latest.ath10k.overrideAttrs (oldAttrs: {
                      patches = (oldAttrs.patches or [ ]) ++ [
                        ./overlays/402-ath_regd_optional.patch
                        ./overlays/403-world_regd_fixup.patch
                      ];
                    });
                  });
                })
              ];
            }
            ./configuration.nix
            ./hosts/router
            agenix.nixosModules.age
            #home-manager.nixosModules.home-manager
            #{
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.users.matthias = { ... }: {
            #    _module.args.unstable = unstable;
            #imports = [ ./hosts/router/home.nix];
            #  };
            #}
          ];
        };
        vmlinux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/vmlinux/base.nix
            ./hosts/vmlinux/vm.nix
            {
              virtualisation.vmVariant.virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            }
          ];
        };
        packages.x86_64-linux.vmlinux = self.nixosConfigurations.vmlinux.config.system.build.vm;
        pi = nixpkgs.lib.nixosSystem {
          system = "armv7";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-2
            ./hosts/pi/configuration.nix
            ./hosts/pi/base.nix
            {
              nixpkgs.config.allowUnsupportedSystem = true;
              nixpkgs.hostPlatform.system = "armv7l-linux";
              nixpkgs.buildPlatform.system = "x86_64-linux";
              virtualisation.vmVariant.virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            }
          ];
        };
      };
    };
}
