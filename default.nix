{ system ? builtins.currentSystem
}:

let fo = (import ./flake.nix).outputs { self = fo; };
in { inherit (fo) util eachDefaultSystem; } // fo.legacyPackages.${system}
