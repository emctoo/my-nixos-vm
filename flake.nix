{
  description = "VM";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs, ... }: {
    packages.x86_64-linux = {
      vm1 = self.nixosConfigurations.vm1.config.system.build.vm;
      vm2 = self.nixosConfigurations.vm2.config.system.build.vm;
    };

    nixosConfigurations = {
      vm1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "vm1"; }
          ./vm.nix
          ./proxy.nix
          ./core.nix
          ./xfce.nix
        ];
      };
      vm2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { networking.hostName = "vm2"; }
          ./vm.nix
          ./proxy.nix
          ./core.nix
          ./cli.nix
        ];
      };
    };
  };
}

