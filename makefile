ALL: install

install:
	nixos-rebuild switch

update:
	nix flake update
	nixos-rebuild switch


