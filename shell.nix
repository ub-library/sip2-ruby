{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.redo-apenwarr
    pkgs.ruby
  ];
}
