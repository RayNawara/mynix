{
  description = "My Ruby/Rails project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ruby-rails.url = "./ruby-rails-flake";
  };

  outputs = { self, nixpkgs, ruby-rails }:
    let
      system = "x86_64-linux";
    in {
      devShell.${system} = ruby-rails.devShell.${system};
    };
}