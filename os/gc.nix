{
  nix.gc.automatic = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}