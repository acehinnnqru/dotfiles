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
            excludesfile = "~/.gitignore";
        };

        init = {
            defaultBranch = "main";
        };

        extraConfig = {
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            push.default = "current";
            pull.rebase = true;
            fetch.prune = true;
        };
    };

    ignore = [
      ".envrc"
      ".direnv/"
    ];
    
    includes = [
        {
            path = "~/.gitconfig.local";
        }
    ];
  };
}
