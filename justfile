_default:
  @just --list

# build the vm
build name="vm1":
  nix build -v ./#nixosConfigurations.{{name}}.config.system.build.vm -o result-{{name}}

# run the vm
run name="vm1": (build name)
  QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result-{{name}}/bin/run-{{name}}-vm

# ssh into the vm
ssh:
  ssh -p 2222 maple@localhost

terminate:
  ssh -p 2222 -t maple@localhost sudo poweroff
