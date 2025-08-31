FLAKE_CFG := ".#" + `cat /etc/hostname`


build: sudo clean
  #!/usr/bin/env nix-shell
  #! nix-shell -p nix-output-monitor -i bash
  nixos-rebuild switch --flake {{FLAKE_CFG}} --log-format internal-json -v |& nom --json

build-and-poweroff: build
  poweroff
trace-build: sudo
	nixos-rebuild switch --flake {{FLAKE_CFG}} --show-trace --option eval-cache false

sudo:
	@echo "uid: $(id -u)"
	@if [[ "$(id -u)" -ne "0" ]]; then \
		 echo "You must be root to perform this action.";\
		 exit 1;\
	fi

nosudo:
	@echo "uid: $(id -u)"
	@if [[ "$(id -u)" -eq "0" ]]; then \
		 echo "You must not be root to perform this action.";\
		 exit 1;\
	fi


clean:
  #!/usr/bin/env bash
  if [ -f "$HOME/.gtkrc-2.0.hm.backup" ] ; then rm "$HOME/.gtkrc-2.0.hm.backup"; fi
  if [ -f "$HOME/.gtkrc-2.0" ] ; then rm "$HOME/.gtkrc-2.0"; fi

# Garbage collect all unused nix store entries
gc: nosudo 
  sudo nix store gc
  sudo nix-collect-garbage --delete-old
  just gitgc
  nix store gc
  nix-collect-garbage --delete-old

# Remove all reflog entries and prune unreachable objects
gitgc:
	git reflog expire --expire-unreachable=now --all
	git gc --prune=now

update input:
  ssh-add
  nix flake lock --update-input {{input}}

update-all:
  ssh-add
  nix flake update

log:
	nix profile history --profile /nix/var/nix/profiles/system
