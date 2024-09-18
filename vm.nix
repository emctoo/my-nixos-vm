# Build this VM with nix build  ./#nixosConfigurations.vm.config.system.build.vm
# Then run is with: ./result/bin/run-nixos-vm
#
# To be able to connect with ssh enable port forwarding with:
# QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm
# Then connect with ssh -p 2222 maple@localhost
{ lib, config, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];

  # Internationalisation options
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Options for the screen
  virtualisation.vmVariant = {
    # https://github.com/NixOS/nixpkgs/blob/5e0ca22929f3342b19569b21b2f3462f053e497b/nixos/modules/virtualisation/qemu-vm.nix#L411
    virtualisation.resolution = {
      x = 1280;
      y = 768;
    };
    virtualisation.memorySize = 2048; # memory in MB, default is 1024
    virtualisation.qemu.options = [
      # Better display option
      "-vga virtio"
      "-display gtk,zoom-to-fit=false"
      # Enable copy/paste
      # https://www.kraxel.org/blog/2021/05/qemu-cut-paste/
      "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
      "-device virtio-serial-pci"
      "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
      # Enable audio / 1
      "-device intel-hda"
      "-device hda-duplex"
    ];
  };

  # Enable sound / 2
  hardware.pulseaudio.enable = true;

  security.sudo.wheelNeedsPassword = false;

  # Enable ssh
  services.sshd.enable = true;

  fonts = {
    fontconfig.enable = true;
    fontDir = { enable = true; };
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      fira-code
      fira-code-symbols

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      wqy_microhei
      wqy_zenhei
      source-han-sans
      source-han-serif
      # sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      jetbrains-mono
    ];
  };

  system.stateVersion = "24.05";
}
