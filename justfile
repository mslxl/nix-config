set shell := ["nu", "-c"]

FLAKE_CFG := ".#" + `cat /etc/hostname`

build: sudo
  #!/usr/bin/env nix-shell
  #! nix-shell -p nix-output-monitor -i bash
  nixos-rebuild switch --flake {{FLAKE_CFG}} --log-format internal-json -v |& nom --json

build-and-poweroff: build
  poweroff
trace-build: sudo
	nixos-rebuild switch --flake {{FLAKE_CFG}} --show-trace --option eval-cache false

sudo:
	@echo ("uid: " + (id -u))
	@if (id -u) != "0" { \
		 echo "You must be root to perform this action.";\
		 exit 1\
	}

# Garbage collect all unused nix store entries
gc: 
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
