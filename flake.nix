{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    ...
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default
    ];
    # use username and hmModules to generate darwinSystem config
    mkDarwin = {
      username,
      hmModules,
    }:
      nix-darwin.lib.darwinSystem {
        modules = [
          ./nix/darwin

          {
            nixpkgs.overlays = overlays;
          }

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = {
              imports = hmModules;
            };

            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit username;};
          }
        ];

        specialArgs = {inherit inputs username;};
      };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#{hostname}
    darwinConfigurations = {
      "acehinnnqru-mbp" = mkDarwin {
        username = "acehinnnqru";
        hmModules = [
          ./nix/home
        ];
      };
    };
  };
}
