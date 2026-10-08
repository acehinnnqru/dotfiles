{
  pkgs,
  inputs,
  ...
}: {
  languages.nix = {
    enable = true;
    lsp.package = pkgs.nil;
  };
  git-hooks.hooks.alejandra.enable = true;
}
