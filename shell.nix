let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    buildInputs = [
      pkgs.poppler_utils
      pkgs.redo-sh
      pkgs.ruby
    ];
  }
