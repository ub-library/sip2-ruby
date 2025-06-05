{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        rubyOverlay = final: prev: {
          ruby_3_4 = prev.ruby_3_4.override {
            bundler = prev.bundler.overrideAttrs ({ postFixup ? "", ... }: {
              postFixup = postFixup + ''
                stubSpec=$(find $out -path '*bundler/stub_specification.rb')
                substituteInPlace $stubSpec \
                  --replace-fail 'warn "Source #{source} is ignoring #{self} because it is missing extensions"' '# redacted because of https://github.com/NixOS/nixpkgs/issues/400243'
              '';
            });
          };
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rubyOverlay ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.ruby_3_4
          ];
        };
      });
}
