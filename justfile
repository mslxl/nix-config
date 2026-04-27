HOSTNAME := `cat /etc/hostname`
FLAKE_CFG := ".#" + `cat /etc/hostname`

_default:
  just --choose


[linux]
build-nom: _nosudo
  #!/usr/bin/env nix-shell
  #! nix-shell -p nix-output-monitor -i bash
  set -euo pipefail
  just clean
  sudo nixos-rebuild switch --flake {{FLAKE_CFG}} --log-format internal-json -v |& nom --json

[macos]
build-nom: _nosudo
  #!/usr/bin/env nix-shell
  #! nix-shell -p nix-output-monitor -i bash
  set -euo pipefail
  nix build .#darwinConfigurations.{{HOSTNAME}}.system --extra-experimental-features 'nix-command flakes'  --log-format internal-json -v |& nom --json
  sudo -E ./result/sw/bin/darwin-rebuild switch --flake {{FLAKE_CFG}}

[macos]
build: _nosudo
  nix build .#darwinConfigurations.aquamarine.system --extra-experimental-features 'nix-command flakes'
  sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#aquamarine

fmt:
	nix fmt . --extra-experimental-features 'nix-command flakes'

[linux]
build-and-poweroff: build
  poweroff

[linux]
trace-build:
	sudo nixos-rebuild switch --flake {{FLAKE_CFG}} --show-trace --option eval-cache false

[macos]
trace-build:
	sudo darwin-rebuild switch --flake {{FLAKE_CFG}} --show-trace --option eval-cache false

_nosudo:
	@echo "uid: $(id -u)"
	@if [[ "$(id -u)" -eq "0" ]]; then \
		 echo "You must not be root to perform this action.";\
		 exit 1;\
	fi

[linux]
clean:
  #!/usr/bin/env bash
  if [ -f "$HOME/.gtkrc-2.0.hm.backup" ] ; then rm "$HOME/.gtkrc-2.0.hm.backup"; fi
  if [ -f "$HOME/.gtkrc-2.0" ] ; then rm "$HOME/.gtkrc-2.0"; fi

# Garbage collect all unused nix store entries
gc: _nosudo 
  sudo nix store gc
  sudo nix-collect-garbage --delete-old
  nix store gc
  nix-collect-garbage --delete-old
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

update input:
  ssh-add
  nix flake update {{input}}

update-all:
  ssh-add
  nix flake update

[linux]
log:
	nix profile history --profile /nix/var/nix/profiles/system
