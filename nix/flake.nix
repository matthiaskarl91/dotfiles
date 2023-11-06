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

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nixos-hardware }: {
    darwinConfigurations."Matthiascmdscale" = nix-darwin.lib.darwinSystem {
      #you can have multiple darwinConfigurations per flake, one per hostname

      system = "aarch64-darwin"; # "x86_64-darwin" if you're using a pre M1 mac
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/matthias/default.nix
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
          home-manager.darwinModules.home-manager
          ./hosts/vmlinux/default.nix
        ];
      };
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
