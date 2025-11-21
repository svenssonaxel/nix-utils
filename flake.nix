{
  description = "Nix utils and historic package versions";
  outputs = { self }:
    let util = (import ./util/default.nix);
        inherit (util.flake-utils) eachDefaultSystem;
    in { inherit util eachDefaultSystem; } //
       eachDefaultSystem (system: {
         legacyPackages = {
           history = import ./history/default.nix { inherit system; };
         };
         checks = import ./checks.nix { inherit system; };
       });
}
