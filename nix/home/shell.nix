{pkgs, envVars ? {}, initExtra ? "", ...}: {
  programs.gpg.enable = true;

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    completionInit = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "tmux"
      ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
          sha256 = "1b4pksrc573aklk71dn2zikiymsvq19bgvamrdffpf7azpq6kxl2";
        };
      }
    ];

    envExtra = pkgs.lib.concatStringsSep "\n" (
      pkgs.lib.mapAttrsToList (name: value: "export ${name}=${pkgs.lib.escapeShellArg value}") envVars
    );

    initExtra = initExtra;
  };

  programs.eza = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "rg --files --hidden --glob '!.git/' --glob '!node_modules/' --glob '!.direnv/'";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      time = {
        disabled = false;
        format = "[$time]($style) ";
      };

      # plain text presets from https://starship.rs/presets/plain-text
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[x](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };

      git_commit = {
        tag_symbol = " tag ";
      };

      git_status = {
        ahead = ">";
        behind = "<";
        diverged = "<>";
        renamed = "r";
        deleted = "x";
      };

      aws.symbol = "aws ";
      azure.symbol = "az ";
      buf.symbol = "buf ";
      bun.symbol = "bun ";
      c.symbol = "C ";
      cpp.symbol = "C++ ";
      cobol.symbol = "cobol ";
      conda.symbol = "conda ";
      container.symbol = "container ";
      crystal.symbol = "cr ";
      cmake.symbol = "cmake ";
      daml.symbol = "daml ";
      dart.symbol = "dart ";
      deno.symbol = "deno ";
      dotnet.symbol = ".NET ";
      directory.read_only = " ro";
      docker_context.symbol = "docker ";
      elixir.symbol = "exs ";
      elm.symbol = "elm ";
      fennel.symbol = "fnl ";
      fossil_branch.symbol = "fossil ";
      gcloud.symbol = "gcp ";
      git_branch.symbol = "git ";
      gleam.symbol = "gleam ";
      golang.symbol = "go ";
      gradle.symbol = "gradle ";
      guix_shell.symbol = "guix ";
      haskell.symbol = "haskell ";
      helm.symbol = "helm ";
      hg_branch.symbol = "hg ";
      java.symbol = "java ";
      julia.symbol = "jl ";
      kotlin.symbol = "kt ";
      lua.symbol = "lua ";
      nodejs.symbol = "nodejs ";
      memory_usage.symbol = "memory ";
      meson.symbol = "meson ";
      nats.symbol = "nats ";
      nim.symbol = "nim ";
      nix_shell.symbol = "nix ";
      ocaml.symbol = "ml ";
      opa.symbol = "opa ";

      os.symbols = {
        AIX = "aix ";
        Alpaquita = "alq ";
        AlmaLinux = "alma ";
        Alpine = "alp ";
        Amazon = "amz ";
        Android = "andr ";
        Arch = "rch ";
        Artix = "atx ";
        Bluefin = "blfn ";
        CachyOS = "cach ";
        CentOS = "cent ";
        Debian = "deb ";
        DragonFly = "dfbsd ";
        Emscripten = "emsc ";
        EndeavourOS = "ndev ";
        Fedora = "fed ";
        FreeBSD = "fbsd ";
        Garuda = "garu ";
        Gentoo = "gent ";
        HardenedBSD = "hbsd ";
        Illumos = "lum ";
        Kali = "kali ";
        Linux = "lnx ";
        Mabox = "mbox ";
        Macos = "mac ";
        Manjaro = "mjo ";
        Mariner = "mrn ";
        MidnightBSD = "mid ";
        Mint = "mint ";
        NetBSD = "nbsd ";
        NixOS = "nix ";
        Nobara = "nbra ";
        OpenBSD = "obsd ";
        OpenCloudOS = "ocos ";
        openEuler = "oeul ";
        openSUSE = "osuse ";
        OracleLinux = "orac ";
        Pop = "pop ";
        Raspbian = "rasp ";
        Redhat = "rhl ";
        RedHatEnterprise = "rhel ";
        RockyLinux = "rky ";
        Redox = "redox ";
        Solus = "sol ";
        SUSE = "suse ";
        Ubuntu = "ubnt ";
        Ultramarine = "ultm ";
        Unknown = "unk ";
        Uos = "uos ";
        Void = "void ";
        Windows = "win ";
      };

      package.symbol = "pkg ";
      perl.symbol = "pl ";
      php.symbol = "php ";
      pijul_channel.symbol = "pijul ";
      pixi.symbol = "pixi ";
      pulumi.symbol = "pulumi ";
      purescript.symbol = "purs ";
      python.symbol = "py ";
      quarto.symbol = "quarto ";
      raku.symbol = "raku ";
      rlang.symbol = "r ";
      ruby.symbol = "rb ";
      rust.symbol = "rs ";
      scala.symbol = "scala ";
      spack.symbol = "spack ";
      solidity.symbol = "solidity ";
      status.symbol = "[x](bold red) ";
      sudo.symbol = "sudo ";
      swift.symbol = "swift ";
      typst.symbol = "typst ";
      terraform.symbol = "terraform ";
      zig.symbol = "zig ";
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    config = {
      whitelist = {
        prefix = ["~/r" "~/ws"];
      };
    };

    nix-direnv = {
      enable = true;
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "nightfox";
    };
  };
}
