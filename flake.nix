{
  description = "Cross-platform system flake (macOS & Linux)";

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
      extraimports,
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
              imports = [./nix/home] ++ hmModules;
            };

            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit username;};
          }
        ];

        specialArgs = {inherit inputs username extraimports;};
      };
    # use username and hmModules to generate nixosSystem config
    mkNixOS = {
      username,
      hmModules,
      extraimports,
      system ? "x86_64-linux",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nix/nixos

          {
            nixpkgs.overlays = overlays;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${username}" = {
              imports = [./nix/home] ++ hmModules;
            };

            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit username;};
          }
        ];

        specialArgs = {inherit inputs username extraimports;};
      };
  in {
    packages.aarch64-darwin.mkDarwin = mkDarwin;
    packages.x86_64-linux.mkNixOS = mkNixOS;
    packages.aarch64-linux.mkNixOS = mkNixOS;

    darwinConfigurations = {
      "acehinnnqru-mbp" = mkDarwin {
        username = "acehinnnqru";
        hmModules = [];
        extraimports = [
          {
            system.primaryUser = "acehinnnqru";
          }
        ];
      };
    };
  };
}
