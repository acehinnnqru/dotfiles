{pkgs, ...}: {
  programs.git = {
    enable = true;
    signing = {
      format = "openpgp";
    };
    settings = {
      user = {
        name = "acehinnnqru";
        email = "acehinnnqru@gmail.com";
      };
      commit = {
        gpgsign = true;
      };
      http = {
        cookiefile = "~/.gitcookies";
      };

      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };

      core = {
        excludesfile = "~/.config/git/ignore";
      };

      init = {
        defaultBranch = "main";
      };

      push = {
        autoSetupRemote = true;
        default = "current";
      };

      pull = {
        rebase = true;
      };

      fetch = {
        prune = true;
      };
    };

    ignores = [
      ".envrc"
      ".direnv/"
      ".DS_Store"
      "Thumbs.db"
    ];

    includes = [
      {
        path = "~/.gitconfig.local";
      }
    ];
  };
}
