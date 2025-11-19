{
  description = "Nix utils and historic package versions";
  outputs = { self }:
    let lib = (import ./util/default.nix);
    in lib.flake-utils.eachDefaultSystem
      (system: {
        legacyPackages = (import ./default.nix) { inherit system; };
        checks = import ./checks.nix { inherit system; };
      });
}
