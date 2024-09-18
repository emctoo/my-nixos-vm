{ pkgs, config, ... }: {
  # X configuration
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      options = "caps:ctrl_modifier";
    };
  };

  services.xserver.desktopManager.xfce = {
    enable = true;
    enableScreensaver = false;
  };

  # lxqt
  # services.xserver.desktopManager.lxqt.enable = true;

  services.xserver.videoDrivers = [ "qxl" ];

  # For copy/paste to work
  services.spice-vdagentd.enable = true;
}
