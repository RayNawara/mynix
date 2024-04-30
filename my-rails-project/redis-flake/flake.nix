{
  description = "Redis development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            redis
          ];

          shellHook = ''
            # Set up Redis
            export REDIS_DIR=$PWD/redis
            export REDIS_PORT=6379

            # Create Redis directory and configuration file
            mkdir -p $REDIS_DIR
            cat > $REDIS_DIR/redis.conf <<EOF
            daemonize no
            bind 127.0.0.1
            port $REDIS_PORT
            dir $REDIS_DIR
            vm-overcommit-memory 1
            EOF

            # Start Redis in the background
            redis-server $REDIS_DIR/redis.conf &

            # Clean up processes on shell exit
            trap "redis-cli -p $REDIS_PORT shutdown" EXIT
          '';
        };
      }
    );
}