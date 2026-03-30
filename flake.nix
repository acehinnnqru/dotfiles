{
  description = "Cross-platform dotfiles flake (macOS & Linux with Home Manager)";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/master";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rt = {
      url = "github:acehinnnqru/rt/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rime-ice = {
      url = "github:iDvel/rime-ice";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    neovim-nightly-overlay,
    rt,
    rime-ice,
    ...
  }: let
    overlays = [
      neovim-nightly-overlay.overlays.default
      (final: prev: {
        rt = rt.packages.${prev.system}.rt;
      })
    ];
    # use username and hmModules to generate darwinSystem config
    mkDarwin = {
      username,
      hmModules,
      extraimports,
      envVars ? {},
      initExtra ? "",
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
              imports =
                [
                  ./nix/home
                  ./nix/darwin/rime.nix
                ]
                ++ hmModules;
            };

            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit username envVars initExtra rime-ice;};
          }
        ];

        specialArgs = {inherit inputs username extraimports;};
      };
    # use username and hmModules to generate standalone Home Manager config
    # for non-NixOS Linux systems (Ubuntu, Debian, etc.)
    mkHome = {
      username,
      hmModules,
      system ? "x86_64-linux",
      envVars ? {},
      initExtra ? "",
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = overlays;
        };
        modules =
          [
            ./nix/home
          ]
          ++ hmModules;
        extraSpecialArgs = {inherit username envVars initExtra;};
      };
  in {
    packages.aarch64-darwin.mkDarwin = mkDarwin;
    packages.x86_64-linux.mkHome = mkHome;
    packages.aarch64-linux.mkHome = mkHome;

    darwinConfigurations = {
      "acehinnnqru-mbp" = mkDarwin {
        username = "acehinnnqru";
        hmModules = [];
        extraimports = [
          {
            system.primaryUser = "acehinnnqru";
            users.users.acehinnnqru.uid = 501;
          }
        ];
      };
    };

    # Standalone Home Manager configurations for non-NixOS Linux systems
    # Usage: home-manager switch --flake "github:acehinnnqru/dotfiles#<hostname>"
    homeConfigurations = {
      # Example: Add your remote hostname here
      # "remote-host" = mkHome {
      #   username = "acehinnnqru";
      #   hmModules = [];
      #   system = "x86_64-linux";  # or "aarch64-linux"
      # };
    };
  };
}
