# Nix utils and historic package versions

## Utils

* `#util.flake-utils`: A reference to [[https://github.com/numtide/flake-utils/][numtide/flake-utils]]
* `#eachDefaultSystem`: Short for `#util.flake-utils.eachDefaultSystem`
* `#util.lib`: A reference to `pkgs.lib` from `nixpkgs`.

## Historic software

Under `#history` you'll find a few collections of software history.
There is also `#history.nixpkgs`, which can then be used to find historic versions of software not included directly under `#history`.
The easiest way to explore is to use shell completion.
Examples:

```sh
> nix run github:svenssonaxel/nix-utils#history.python.v2_6_7 -- --version
Python 2.6.7
> nix run github:svenssonaxel/nix-utils#history.nixpkgs.v20_03.pkgs.gzip -- --version | head -n1
gzip 1.10
> nix shell github:svenssonaxel/nix-utils#history.poppler-utils.v0_67_0 -c pdfinfo -v 2>&1 | head -n1
pdfinfo version 0.67.0
```
