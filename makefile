FLAKE_CFG := .\#$(shell cat /etc/hostname)

build: sudo
	nixos-rebuild switch --flake $(FLAKE_CFG)
trace-build: sudo
	nixos-rebuild switch --flake $(FLAKE_CFG) --show-trace --option eval-cache false

sudo:
ifneq ($(shell id -u), 0)
	@echo "You must be root to perform this action."
	@exit 1
endif


gc: sudo
	nix store gc --debug
	nix-collect-garbage --delete-old

update:
	nix flake update
