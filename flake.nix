{
  description = "Nix utils and historic package versions";
  outputs = { self }:
    (import ./util/default.nix).flake-utils.eachDefaultSystem
      (system: {
        legacyPackages = (import ./default.nix) { inherit system; };
      });
}
