{ pkgs, config, ... }: {
  # A default user able to use sudo
  users.users.maple = {
    isNormalUser = true;
    home = "/home/maple";
    extraGroups = [ "wheel" ];
    initialPassword = "asdf";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  users.users.maple.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICadLJygz4Im8wrekaV/hNFLDN59iIIObpBu3GYKlIZm maple"
  ];

  services.displayManager.autoLogin.user = "maple";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    fish
    zoxide
    atuin
    direnv
    starship

    ldns
    # hey
    httpie
    curl

    neovim
    git
    gnumake
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
    pciutils
  ];
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv = { enable = true; };
  };
}
