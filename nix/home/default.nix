{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./shell.nix
    ./tmux.nix
  ];
  home.username = "${username}";
  home.homeDirectory = pkgs.lib.mkForce (
    if pkgs.stdenv.isLinux
    then "/home/${username}"
    else "/Users/${username}"
  );

  home.packages = with pkgs; [
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

    # workspace
    tmux
    direnv
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
      c = "clear";
    }
    // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      rm = "trash";
    };

  home.sessionVariables = {
    FZF_CTRL_T_COMMAND = "";
    EDITOR = "nvim";
  };

  home.file = {
    ".config/tmux".source = ../../config/tmux;
    ".config/tmux".recursive = true;
    ".config/nvim".source = ../../config/nvim;
    ".config/nvim".recursive = true;
    ".config/ghostty".source = ../../config/ghostty;
    ".config/ghostty".recursive = true;
    ".config/karabiner".source = ../../config/karabiner;
    ".config/karabiner".recursive = true;
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
