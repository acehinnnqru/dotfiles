{
  pkgs,
  lib,
  inputs,
  username,
  extraimports,
  ...
}: {
  imports =
    []
    ++ extraimports;

  # List packages installed in system profile. To search by name, run:
  # $ nix search nixpkgs wget
  environment.systemPackages = [
  ];

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix environment.
  programs.zsh.enable = true;

  # Set Git commit hash for nixos-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ nixos-rebuild changelog
  system.stateVersion = "24.05";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  environment.variables = {
  };

  # Trusted users (set in trusted-users ) can always connect to the Nix daemon.
  # If set to true, Nix will ignore the allowSubstitutes attribute in derivations
  # and always attempt to use available substituters.
  # This setting is part of an experimental feature.
  nix.settings.trusted-users = [username];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-substituters = [
    "nix-community.cachix.org"
    "cache.nixos.org"
  ];

  # enable nix auto gc
  # default interval: at 3:15 of every Sunday
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 7d";

  users = {
    users = {
      "${username}" = {
        shell = pkgs.zsh;
        description = "${username}";
        home = "/home/${username}";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
      };
    };
  };

  # Enable sudo
  security.sudo.enable = true;
}

