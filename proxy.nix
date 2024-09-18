{ pkgs, config, ... }: {
  networking.proxy = {
    default = "http://192.168.8.53:1081";
    noProxy =
      "127.0.0.1,localhost,192.168.8.1/24,mirrors.tuna.tsinghua.edu.cn,mirror.sjtu.edu.cn,*.so1z.ltd";
  };
}
