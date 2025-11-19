{
  flake-utils = import (builtins.fetchGit {
    url = "https://github.com/numtide/flake-utils.git";
    narHash = "sha256-l0KFg5HjrsfsO/JpG+r7fRrqm12kzFHyUHqHCVpMMbI=";
    rev = "11707dc2f618dd54ca8739b309ec4fc024de578b";
  });
  lib = (import ../history/default.nix {}).nixpkgs.latest.pkgs.lib;
}
