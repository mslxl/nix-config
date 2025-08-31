{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.aria = {
    enable = lib.mkEnableOption "Enable aria";
    daemon = {
      enable = lib.mkEnableOption "Enable aria deamon";
      file-allocation = lib.mkOption {
        type = with lib.types; (enum ["none" "prealloc" "trunc" "falloc"]);
        default = "none";
        description = ''
          文件预分配方式, 可选：none, prealloc, trunc, falloc, 默认:prealloc
          预分配对于机械硬盘可有效降低磁盘碎片、提升磁盘读写性能、延长磁盘寿命。
          机械硬盘使用 ext4（具有扩展支持），btrfs，xfs 或 NTFS（仅 MinGW 编译版本）等文件系统建议设置为 falloc
          若无法下载，提示 fallocate failed.cause：Operation not supported 则说明不支持，请设置为 none
          prealloc 分配速度慢, trunc 无实际作用，不推荐使用。
          固态硬盘不需要预分配，只建议设置为 none ，否则可能会导致双倍文件大小的数据写入，从而影响寿命。
        '';
      };
      max-concurrent-downloads = lib.mkOption {
        type = lib.types.ints.positive;
        default = 5;
        description = ''
          最大同时下载任务数, 运行时可修改,
        '';
      };
      max-connection-per-server = lib.mkOption {
        type = lib.types.ints.between 1 16;
        default = 1;
        description = ''
          单服务器最大连接线程数, 任务添加时可指定, 默认:1
          最大值为 16 (增强版无限制), 且受限于单任务最大连接线程数(split)所设定的值。
        '';
      };
      split = lib.mkOption {
        type = lib.types.ints.positive;
        default = 5;
        description = ''
          分片数
        '';
      };
      lowest-speed-limit = lib.mkOption {
        type = lib.types.strMatching "0|([0-9]+(K|M))";
        default = "0";
        description = ''
          最低下载速度限制。当下载速度低于或等于此选项的值时关闭连接（增强版本为重连），此选项与 BT 下载无关。单位 K 或 M ，默认：0 (无限制)
        '';
      };
      max-overall-download-limit = lib.mkOption {
        type = lib.types.strMatching "0|([0-9]+(K|M))";
        default = "0";
        description = ''
          全局最大下载速度限制, 运行时可修改, 默认：0 (无限制)
        '';
      };
      max-download-limit = lib.mkOption {
        type = lib.types.strMatching "0|([0-9]+(K|M))";
        default = "0";
        description = ''
          单最大下载速度限制, 默认：0 (无限制)
        '';
      };
      disable-ipv6 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          禁用 IPv6, 默认:false
        '';
      };
      no-netrc = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          禁用 netrc 支持
        '';
      };
      min-tls-version = lib.mkOption {
        type = with lib.types; (enum ["TLSv1.1" "TLSv1.2" "TLSv1.3"]);
        default = "TLSv1.2";
        description = ''
          最低 TLS 版本，可选：TLSv1.1、TLSv1.2、TLSv1.3 默认:TLSv1.2
        '';
      };

      listen-port = lib.mkOption {
        type = lib.types.port;
        default = 51413;
        description = ''
          BT 监听端口(TCP), 默认:6881-6999
          直通外网的设备，比如 VPS ，务必配置防火墙和安全组策略允许此端口入站
          内网环境的设备，比如 NAS ，除了防火墙设置，还需在路由器设置外网端口转发到此端口
        '';
      };

      dht-listen-port = lib.mkOption {
        type = lib.types.port;
        default = 51413;
        description = ''
          DHT 网络与 UDP tracker 监听端口(UDP), 默认:6881-6999
          因协议不同，可以与 BT 监听端口使用相同的端口，方便配置防火墙和端口转发策略。
        '';
      };
      enable-dht = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          启用 IPv4 DHT 功能, PT 下载(私有种子)会自动禁用, 默认:true
        '';
      };
      enable-dht6 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          启用 IPv6 DHT 功能, PT 下载(私有种子)会自动禁用，默认:false
          在没有 IPv6 支持的环境开启可能会导致 DHT 功能异常
        '';
      };
      bt-external-ip = lib.mkOption {
        type = lib.types.strMatching "(^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$)?";
        default = "";
        description = ''
          指定 BT 和 DHT 网络中的 IP 地址
          使用场景：在家庭宽带没有公网 IP 的情况下可以把 BT 和 DHT 监听端口转发至具有公网 IP 的服务器，在此填写服务器的 IP ，可以提升 BT 下载速率。
        '';
      };
      dht-entry-point = lib.mkOption {
        type = lib.types.str;
        default = "dht.transmissionbt.com:6881";
        description = ''
          IPv4 DHT 网络引导节点
        '';
      };
      dht-entry-point6 = lib.mkOption {
        type = lib.types.str;
        default = "dht.transmissionbt.com:6881";
        description = ''
          IPv6 DHT 网络引导节点
        '';
      };
      bt-max-peers = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 55;
        description = ''
          BT 下载最大连接数（单任务），运行时可修改。0 为不限制，默认:55
          理想情况下连接数越多下载越快，但在实际情况是只有少部分连接到的做种者上传速度快，其余的上传慢或者不上传。
          如果不限制，当下载非常热门的种子或任务数非常多时可能会因连接数过多导致进程崩溃或网络阻塞。
          进程崩溃：如果设备 CPU 性能一般，连接数过多导致 CPU 占用过高，因资源不足 Aria2 进程会强制被终结。
          网络阻塞：在内网环境下，即使下载没有占满带宽也会导致其它设备无法正常上网。因远古低性能路由器的转发性能瓶颈导致。
        '';
      };

      bt-request-peer-speed-limit = lib.mkOption {
        type = lib.types.strMatching "0|([0-9]+[KM])";
        default = "10M";
        description = ''
          BT 下载期望速度值（单任务），运行时可修改。单位 K 或 M 。默认:50K
          BT 下载速度低于此选项值时会临时提高连接数来获得更快的下载速度，不过前提是有更多的做种者可供连接。
          实测临时提高连接数没有上限，但不会像不做限制一样无限增加，会根据算法进行合理的动态调节。
        '';
      };

      max-overall-upload-limit = lib.mkOption {
        type = lib.types.strMatching "0|([0-9]+(K|M))";
        default = "2M";
        description = ''
          全局最大上传速度限制, 运行时可修改, 默认:0 (无限制)
          设置过低可能影响 BT 下载速度
        '';
      };
      max-upload-limit = lib.mkOption {
        type = lib.types.strMatching "0|([0-9]+(K|M))";
        default = "0";
        description = ''
          单任务上传速度限制, 默认:0 (无限制)
        '';
      };
      seed-ratio = lib.mkOption {
        type = lib.types.float;
        default = 1.5;
        description = ''
          最小分享率。当种子的分享率达到此选项设置的值时停止做种, 0 为一直做种, 默认:1.0
          强烈建议您将此选项设置为大于等于 1.0
        '';
      };
      seed-time = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 2800;
        description = ''
          最小做种时间（分钟）。设置为 0 时将在 BT 任务下载完成后停止做种。
        '';
      };
      bt-force-encryption = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          BT强制加密, 默认: false
          启用后将拒绝旧的 BT 握手协议并仅使用混淆握手及加密。可以解决部分运营商对 BT 下载的封锁，且有一定的防版权投诉与迅雷吸血效果。
          此选项相当于后面两个选项(bt-require-crypto=true, bt-min-crypto-level=arc4)的快捷开启方式，但不会修改这两个选项的值。
        '';
      };
      user-agent = lib.mkOption {
        type = lib.types.str;
        default = "user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/93.0.4577.63 Safari/537.36 Edg/93.0.961.47";
        description = ''
          自定义 User Agent
        '';
      };
      peer-agent = lib.mkOption {
        type = lib.types.str;
        default = "Deluge 1.3.15";
        description = ''
          BT 客户端伪装
          PT 下载需要保持 user-agent 和 peer-agent 两个参数一致
        '';
      };
      peer-id-prefix = lib.mkOption {
        type = lib.types.str;
        default = "-DE13F0-";
        description = ''
          BT 客户端伪装
          PT 下载需要保持 user-agent 和 peer-agent 两个参数一致
        '';
      };
      rpc-allow-origin-all = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          接受所有远程请求, 默认:false
        '';
      };
      rpc-listen-all = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          允许外部访问, 默认:false
        '';
      };
      rpc-listen-port = lib.mkOption {
        type = lib.types.port;
        default = 6800;
        description = ''
          RPC 监听端口, 默认:6800
        '';
      };
      rpc-secret = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          密码
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.modules.aria.enable {
      home.packages = with pkgs; [
        aria
      ];
    })

    (lib.mkIf config.modules.aria.daemon.enable
      {
        xdg.configFile."aria2/aria2-no-bt-tracker.conf".text = let
          cfg = config.modules.aria.daemon;
          xdg = config.xdg;
        in ''
          # Generated by Home Manager.

          dir=${xdg.userDirs.download}
          disk-cache=64M

          file-allocation=${cfg.file-allocation}
          no-file-allocation-limit=64M

          continue=true
          always-resume=false
          max-resume-failure-tries=0
          remote-time=true

          input-file=${xdg.dataHome}/aria2/aria2.session
          save-session=${xdg.dataHome}/aria2/aria2.session
          save-session-interval=1
          auto-save-interval=20
          force-save=false

          # Download
          max-file-not-found=10
          max-tries=0
          retry-wait=10
          connect-timeout=10
          timeout=10

          max-concurrent-downloads=${builtins.toString cfg.max-concurrent-downloads}
          max-connection-per-server=${builtins.toString cfg.max-connection-per-server}
          split=${builtins.toString cfg.split}
          min-split-size=4M
          piece-length=1M
          allow-piece-length-change=true
          lowest-speed-limit=${cfg.lowest-speed-limit}
          max-overall-download-limit=${cfg.max-overall-download-limit}
          max-download-limit=${cfg.max-download-limit}

          disable-ipv6=${lib.boolToString cfg.disable-ipv6}
          http-accept-gzip=true
          reuse-uri=false
          no-netrc=${lib.boolToString cfg.no-netrc}
          allow-overwrite=false
          auto-file-renaming=true
          content-disposition-default-utf8=true
          min-tls-version=${cfg.min-tls-version}

          # BT
          listen-port=${builtins.toString cfg.listen-port}
          dht-listen-port=${builtins.toString cfg.dht-listen-port}
          enable-dht=${lib.boolToString cfg.enable-dht}
          enable-dht6=${lib.boolToString cfg.enable-dht6}
          bt-external-ip=${cfg.bt-external-ip}

          dht-file-path=${xdg.dataHome}/aria2/dht.dat
          dht-file-path6=${xdg.dataHome}/aria2/dht6.dat

          dht-entry-point=${cfg.dht-entry-point}
          dht-entry-point6=${cfg.dht-entry-point6}
          bt-enable-lpd=true
          #bt-lpd-interface=
          enable-peer-exchange=true

          bt-max-peers=${builtins.toString cfg.bt-max-peers}
          bt-request-peer-speed-limit=${cfg.bt-request-peer-speed-limit}
          max-overall-upload-limit=${cfg.max-overall-upload-limit}
          max-upload-limit=${cfg.max-upload-limit}

          seed-ratio=${builtins.toString cfg.seed-ratio}
          seed-time=${builtins.toString cfg.seed-time}

          bt-hash-check-seed=true
          bt-seed-unverified=false

          bt-tracker-connect-timeout=10
          bt-tracker-timeout=10
          bt-prioritize-piece=head=32M,tail=32M
          rpc-save-upload-metadata=true
          follow-torrent=true
          pause-metadata=false
          bt-save-metadata=true
          bt-load-saved-metadata=true
          bt-remove-unselected-file=true
          bt-force-encryption=${lib.boolToString cfg.bt-force-encryption}

          bt-detach-seed-only=true

          user-agent=${cfg.user-agent}
          peer-agent=${cfg.peer-agent}
          peer-id-prefix=${cfg.peer-id-prefix}


          # Log
          #log-level=warn
          console-log-level=notice
          quiet=false
          summary-interval=0
          show-console-readout=false

          # RPC

          enable-rpc=true
          rpc-allow-origin-all=${lib.boolToString cfg.rpc-allow-origin-all}
          rpc-listen-all=${lib.boolToString cfg.rpc-listen-all}

          rpc-listen-port=${builtins.toString cfg.rpc-listen-port}
          ${
            if cfg.rpc-secret == null
            then "# NO SECRET"
            else "rpc-secret=${cfg.rpc-secret}"
          }
          rpc-max-request-size=10M
        '';

        # TODO: 额外配置命令 on-bt-download-complete 等
        # 理想情况下，应该将文件下载到缓存目录，并在下载完成后将文件移动到真正的下载目录
        # 如果是 BT 下载，则应该将文件复制到下载目录，并在做种目标达成后再删除文件
        # 这可以用下载完成后执行命令实现

        systemd.user.services.aria = {
          Unit = {
            Description = "Aria Download Daemon";
            After = ["network.target"];
          };
          Install = {
            # WantedBy = ["multi-user.target"];
            WantedBy = ["default.target"];
          };
          Service = {
            Type = "simple";
            ExecStartPre = "${pkgs.writeShellScript "aria2-daemon-init" ''
              [ ! -d "${config.xdg.dataHome}/aria2/" ] && mkdir "${config.xdg.dataHome}/aria2/"

              [ ! -f "${config.xdg.dataHome}/aria2/aria2.session" ] && touch "${config.xdg.dataHome}/aria2/aria2.session"

              ${
                if config.modules.aria.daemon.enable-dht
                then ''
                  [ ! -f "${config.xdg.dataHome}/aria2/dht.dat" ] && curl -fsSL -o "${config.xdg.dataHome}/aria2/dht.dat" "https://github.com/P3TERX/aria2.conf/raw/master/dht.dat"
                ''
                else "# DHT was disabled"
              }
              ${
                if config.modules.aria.daemon.enable-dht6
                then ''
                  [ ! -f "${config.xdg.dataHome}/aria2/dht6.dat" ] && curl -fsSL -o "${config.xdg.dataHome}/aria2/dht6.dat" "https://github.com/P3TERX/aria2.conf/raw/master/dht6.dat"
                ''
                else "# DHT6 was disabled"
              }

              conf_nobt="${config.xdg.configHome}/aria2/aria2-no-bt-tracker.conf"
              conf="${config.xdg.configHome}/aria2/aria2.conf"
              conf_temp="${config.xdg.configHome}/aria2/temp.conf"

              cat "$conf_nobt" > "$conf_temp"
              curl -fsSL https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all_aria2.txt | sed '1s/^/bt-tracker=/' >> "$conf_temp"
              if [[ $? -eq 0 ]]; then
                  mv "$conf_temp" "$conf"
              fi
              if [ ! -f "$conf" ]; then
                  cat "$conf_nobt" > "$conf"
              fi
            ''}";
            ExecStart = "${pkgs.aria2}/bin/aria2c --conf-path ${config.xdg.configHome}/aria2/aria2.conf";
            Restart = "on-failure";
          };
        };
      })
  ];
}
