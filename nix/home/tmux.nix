{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    extraConfig = builtins.readFile ../../config/tmux/tmux-extra.conf;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g status-right ""
          set -g @resurrect-dir '~/.tmux/resurrect'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          # save sessions every 5 mins
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
  };
}
