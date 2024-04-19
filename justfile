set shell := ["nu", "-c"]

FLAKE_CFG := ".#" + `cat /etc/hostname`

build: sudo
	nixos-rebuild switch --flake {{FLAKE_CFG}}
trace-build: sudo
	nixos-rebuild switch --flake {{FLAKE_CFG}} --show-trace --option eval-cache false

sudo:
	@echo ("uid: " + (id -u))
	@if (id -u) != "0" { \
		 echo "You must be root to perform this action.";\
		 exit 1\
	}

gc: sudo
	nix store gc --debug
	nix-collect-garbage --delete-old

update:
	nix flake update
