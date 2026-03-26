# dotfiles

Rewrote it in nix.

My dotfiles in use. Including configs for tmux, zsh, neovim and alacritty.

- For neovim, mostly about rust, go, web development.
- For zsh, mostly about zinit.
- For tmux, contains some settings and plugins.

# Screenshots

![tmux & nvim](./screenshots/screenshot.png "tmux & nvim")

# Usage

## Fresh Installation on new devices

1. Install Nix first

Follow the [Installation Wiki](https://nixos.org/download/#download-nix) to install nix.

2. Add new own host config in [flake.nix](./flake.nix).

Add new host config in the `darwinConfigurations` or `homeConfigurations` section based on the os type.

For example, if you are using a new MacBook, you can add the following config:

```nix
darwinConfigurations = {
  #
  "<here is your hostname>" = mkDarwin {
    username = "<your username>";
    hmModules = [];
    extraimports = [
      {
        system.primaryUser = "<your username>";
        # this line is necessary for the system to be able to use the username.
        users.users."<your username>".uid = 501;
      }
    ];
  };
};
```

3. Follow the instructions in the [Makefile](./Makefile) to build and switch the configuration.

For example, if you are using a new MacBook, you can run the following command:

```bash
make fresh-build-macos hostname=xxx
```

After that, you can run the following command to switch the configuration:

```bash
make switch-macos hostname=xxx
```

After that, you can run the following command to build the configuration:

```bash
make build-macos hostname=xxx
```

If you are using a new Linux system, you can run the following command:

```bash
make fresh-build-linux hostname=xxx
```

After that, you can run the following command to switch the configuration:

```bash
make switch-linux hostname=xxx
```