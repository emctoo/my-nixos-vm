# Build this VM with nix build  ./#nixosConfigurations.vm.config.system.build.vm
# Then run is with: ./result/bin/run-nixos-vm
#
# To be able to connect with ssh enable port forwarding with:
# QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm
# Then connect with ssh -p 2222 maple@localhost
{ lib, config, pkgs, ... }:
{
  # Internationalisation options
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # Options for the screen
  virtualisation.vmVariant = {
    # https://github.com/NixOS/nixpkgs/blob/5e0ca22929f3342b19569b21b2f3462f053e497b/nixos/modules/virtualisation/qemu-vm.nix#L411
    # virtualisation.resolution = { x = 1024; y = 768; }; # window resolution, default is 1024x768
    virtualisation.resolution = { x = 1280; y = 768; }; # window resolution, default is 1024x768
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
    ];
  };

  # A default user able to use sudo
  users.users.maple = {
    isNormalUser = true;
    home = "/home/maple";
    extraGroups = [ "wheel" ];
    initialPassword = "secret";
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  users.users.maple.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICadLJygz4Im8wrekaV/hNFLDN59iIIObpBu3GYKlIZm maple''
  ];

  security.sudo.wheelNeedsPassword = false;

  # X configuration
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:ctrl_modifier";

  services.displayManager.autoLogin.user = "maple";

  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.desktopManager.xfce.enableScreensaver = false;

  # services.xserver.desktopManager.lxqt.enable = true;

  services.xserver.videoDrivers = [ "qxl" ];

  # For copy/paste to work
  services.spice-vdagentd.enable = true;

  # Enable ssh
  services.sshd.enable = true;

  networking.proxy = {
    default = "http://192.168.8.53:1081";
    noProxy = "127.0.0.1,localhost,192.168.8.1/24,mirrors.tuna.tsinghua.edu.cn,mirror.sjtu.edu.cn,*.so1z.ltd";
  };

  # Included packages here
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    fish
    ldns
    # hey
    httpie
    curl

    neovim
    git
    make
    unzip
    gcc
    ripgrep
    xclip

    # htop
    glances
    firefox
    alacritty
    rclone
    rclone-browser
    # wrk
  ];

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
