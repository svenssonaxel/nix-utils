{ system ? builtins.currentSystem
}:

rec {
  nixpkgs = import ./nixpkgs.nix {
    inherit system; };
  poppler-utils = import ./poppler-utils.nix {
    inherit system; history_nixpkgs = nixpkgs; };
  python = import ./python.nix {
    inherit system; history_nixpkgs = nixpkgs; };
}
