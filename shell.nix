{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.poppler_utils
    pkgs.redo-sh
    pkgs.ruby
  ];
}
