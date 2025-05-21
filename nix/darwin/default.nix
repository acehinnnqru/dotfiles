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
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
  ];

  # Auto upgrade nix package and the daemon service.
  nix.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      menuExtraClock.Show24Hour = true; # show 24 hour clock

      NSGlobalDomain.AppleShowAllFiles = true;
      # other macOS's defaults configuration.
      # ......
    };
  };

  environment.variables = {
  };

  # ability to use TouchID for sudo auth
  security.pam.services.sudo_local.touchIdAuth = true;

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

  users = {
    users = {
      "${username}" = {
        shell = pkgs.zsh;
        description = "${username}";
        home = "/Users/${username}";
      };
    };
  };

  launchd.user.agents = {};

  # homebrew support, only use casks
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";
  homebrew.taps = [
    "daipeihust/tap"
    "laishulu/homebrew"
  ];
  homebrew.global.autoUpdate = true;
  homebrew.onActivation.autoUpdate = true;
  homebrew.onActivation.upgrade = true;
  homebrew.casks = import ./casks.nix;
  homebrew.brews = import ./brews.nix;
}
