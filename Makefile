HOST ?= $(shell hostname)

fresh-build-macos:
	which nix
	sudo nix run --extra-experimental-features flakes --extra-experimental-features nix-command nix-darwin/master#darwin-rebuild -- build --flake .#$(HOST)

fresh-build-linux:
	which nix
	sudo nix run --extra-experimental-features flakes --extra-experimental-features nix-command home-manager/master#home-manager -- build --flake .#$(HOST)

build-macos:
	which nix
	which darwin-rebuild
	darwin-rebuild build --flake .#$(HOST)

switch-macos:
	which nix
	which darwin-rebuild
	sudo darwin-rebuild switch --flake .#$(HOST)

switch-linux:
	which nix
	which home-manager
	home-manager switch --flake .#$(HOST)

build-linux:
	which nix
	which home-manager
	home-manager build --flake .#$(HOST)

mv-nix-conf:
	sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.backup