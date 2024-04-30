{
  description = "Ruby and Rails development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    postgresql.url = "/home/ray/my-rails-project/postgresql-flake";
    redis.url = "/home/ray/my-rails-project/redis-flake";
  };

  outputs = { self, nixpkgs, flake-utils, postgresql, redis }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            ruby_3_2
            bundix
            postgresql.devShell.${system}
            # Uncomment the following line if you need Redis
            # redis.devShell.${system}
          ];

          shellHook = ''
            # Set up the environment
            export GEM_HOME=$PWD/.gem
            export PATH=$GEM_HOME/bin:$PATH
          '';
        };
      }
    );
}