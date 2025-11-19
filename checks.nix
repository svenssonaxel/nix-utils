{ system
}:

{
  history = import ./history/checks.nix { inherit system; };
}
