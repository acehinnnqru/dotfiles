{
  pkgs,
  inputs,
  ...
}: {
  languages.nix = {
    enable = true;
    lsp.package = pkgs.nil;
  };

  packages = [
    pkgs.alejandra
  ];
}
