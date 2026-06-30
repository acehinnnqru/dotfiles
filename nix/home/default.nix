{
  pkgs,
  lib,
  username,
  ...
}: let
  brewCompletions = builtins.readFile (pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Homebrew/brew/dc7337a90f7c5e8addcd39284329ee28a67bdb8d/completions/zsh/_brew";
    sha256 = "01rgqa5kzhkr0bqnsz85g3hqvm0nbs34imnr151wp4wadrl1334k";
  });
in {
  imports = [
    ./shell.nix
    ./tmux.nix
    ./git.nix
  ];
  home.username = "${username}";
  home.homeDirectory = pkgs.lib.mkDefault (
    if pkgs.stdenv.isLinux
    then "/home/${username}"
    else "/Users/${username}"
  );

  home.packages = with pkgs;
    [
      gnupg
      git
      ## editor
      vim
      neovim

      ## make life better
      zoxide
      starship
      tokei

      ## dev
      # utils
      fzf
      lazygit
      sesh
      ripgrep
      eza
      bat
      watchexec
      curl

      # workspace
      tmux
      direnv

      tree-sitter

      # for rust cache
      sccache

      # custom
      rt
    ]
    ++ pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin
    [
      trashy
    ];

  home.shellAliases =
    {
      # replace ls with eza
      ls = "eza";
      l = "eza -lbF --git";
      ll = "eza -lbGF --git";
      llm = "eza -lbGd --git --sort=modified";
      la = "eza -lbhHigUmuSa --time-style=long-iso --git --color-scale";
      lx = "eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale";
      lt = "eza --tree --level=2";

      # personal aliases
      vim = "nvim";
      v = "nvim";
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      rm = "trash";
    };

  home.sessionVariables = {
    FZF_CTRL_T_COMMAND = "";
    FZF_ALT_C_COMMAND = "";
    EDITOR = "nvim";
  };

  home.file =
    {
      ".config/tmux".source = ../../config/tmux;
      ".config/tmux".recursive = true;
      ".config/nvim".source = ../../config/nvim;
      ".config/nvim".recursive = true;
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      ".config/ghostty".source = ../../config/ghostty;
      ".config/ghostty".recursive = true;
      ".config/karabiner".source = ../../config/karabiner;
      ".config/karabiner".recursive = true;
      ".zsh/completions/_brew".text = brewCompletions;
    };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
