{ system
}:

let
  history = import ./default.nix { inherit system; };
  pkgs = history.nixpkgs.latest.pkgs;
  inherit (pkgs.lib) hasPrefix mapAttrsToList concatMapStringsSep getName;
  inherit (builtins) hasAttr;
  attrCanon = builtins.replaceStrings ["v" "_"] ["" "."];
  attrMatchesVer = attr: ver:
    (hasPrefix "${attrCanon attr}." ver) || ((attrCanon attr) == ver);
  progname = pkg: if (hasAttr "meta" pkg) && (hasAttr "mainProgram" pkg.meta)
                  then pkg.meta.mainProgram
                  else (if hasAttr "pname" pkg
                        then pkg.pname
                        else getName pkg.name);
  verList = coll:
    mapAttrsToList
      (attr: pkg:
        assert attrMatchesVer attr pkg.version;
        { inherit attr pkg; })
      coll;

  nixpkgsChecksScript =
    concatMapStringsSep "\n"
      ({attr, pkg}: if hasPrefix "v" attr then ''
        pkg="${pkg}"
        if [ -e "$pkg/.version" ]
        then actual="$(cat "$pkg/.version")"
        elif [ -e "$pkg/VERSION" ]
        then actual="$(cat "$pkg/VERSION")"
        elif [ -e "$pkg/pkgs/VERSION" ]
        then actual="$(cat "$pkg/pkgs/VERSION")"
        else actual=""
        fi
        expected="${attrCanon attr}"
        if [[ $expected =~ ^0\.[1-4]$ ]];
        then [ -z "$actual" ]
        else x [ "$actual" == "$expected" ]
        fi
      '' else "")
      (mapAttrsToList (attr: pkg:
        { inherit attr; pkg = pkg.src; })
        history.nixpkgs);

  gsChecksScript =
    concatMapStringsSep "\n"
      ({attr, pkg}: ''
        program="${pkg}/bin/${progname pkg}"
        x [ -e "$program" ]
        actual="$($program --version)"
        expected="${pkg.version}"
        x [ "$actual" == "$expected" ]
      '')
      (verList history.ghostscript);

  popplerChecksScript =
    concatMapStringsSep "\n"
      ({attr, pkg}: ''
        program="${pkg}/bin/pdfinfo"
        ls -lad ${pkg}
        ls -la ${pkg}
        ls -la ${pkg}/bin
        x [ -e "$program" ]
        actual="$($program -v 2>&1 | sed -r 's/.* //;2,$d')"
        expected="${pkg.version}"
        x [ "$actual" == "$expected" ]
      '')
      (verList history.poppler-utils);

  pythonChecksScript =
    concatMapStringsSep "\n"
      ({attr, pkg}: ''
        program="${pkg}/bin/${progname pkg}"
        x [ -e "$program" ]
        actual="$($program --version 2>&1)"
        expected="${pkg.version}"
        x [ "$actual" == "Python $expected" ]
      '')
      (verList history.python);

in pkgs.stdenv.mkDerivation {
  pname = "history-python-check";
  version = "unversioned";
  phases = [ "buildPhase" ];
  buildPhase = ''
    set -eu
    x() { echo "$@"; "$@"; }
    ${nixpkgsChecksScript}
    ${popplerChecksScript}
    ${gsChecksScript}
    ${pythonChecksScript}
    mkdir -p "$out"
    echo "all python history checks passed" > "$out/result"
  '';
}

