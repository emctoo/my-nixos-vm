_default:
  @just --list

# build the vm
build:
  nix build ./#nixosConfigurations.vm.config.system.build.vm

# run the vm
run: build
  QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm

# ssh into the vm
ssh:
  ssh -p 2222 maple@localhost
