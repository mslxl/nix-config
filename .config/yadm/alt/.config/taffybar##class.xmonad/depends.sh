type stack >/dev/null 2>&1 || exit 1
type git >/dev/null 2>&1 || exit 1

if [[ ! -d "./xmonad" ]]; then
    git clone https://github.com/xmonad/xmonad --depth 1
fi


if [[ ! -d "./xmonad-contrib" ]]; then
    git clone https://github.com/xmonad/xmonad-contrib --depth 1
fi

function pull(){
  root=$(pwd)
  cd "$1"
  git pull
  cd "$root"
}

pull ./xmonad/
pull ./xmonad-contrib/
