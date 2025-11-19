{ system ? builtins.currentSystem
}:

rec {
  ghostscript = import ./ghostscript.nix {
    inherit system; history_nixpkgs = nixpkgs; };
  nixpkgs = import ./nixpkgs.nix {
    inherit system; };
  poppler-utils = import ./poppler-utils.nix {
    inherit system; history_nixpkgs = nixpkgs; };
  python = import ./python.nix {
    inherit system; history_nixpkgs = nixpkgs; };
}
