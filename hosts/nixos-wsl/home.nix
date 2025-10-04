{pkgs, ...}: {
  modules = {
    aria.enable = false;
    wakatime.enable = true;
  };
  programs.zsh.initContent = ''
    function proxyEnv(){
      ip=$(ip route show | grep -i default | awk '{ print $3}')
      port=20171
      case "$1" in
        "enable")
          echo "set proxy variable to http://$ip:$port"
          export http_proxy="http://$ip:$port"
          export https_proxy="http://$ip:$port"
          export all_proxy="http://$ip:$port"
          export ALL_PROXY="http://$ip:$port"
          ;;
        "disable")
          unset http_proxy
          unset https_proxy
          unset all_proxy
          unset ALL_PROXY
          ;;
        "inspect")
          echo "expected proxy address is http://$ip:$port"
          echo "current proxy address is $all_proxy"
          ;;
        *)
          echo "proxyEnv <enable|disable|inspect>";;
      esac
    }
  '';
}
