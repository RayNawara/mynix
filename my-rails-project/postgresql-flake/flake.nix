{
  description = "PostgreSQL development environment";

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
            postgresql
          ];

          shellHook = ''
            # Set up PostgreSQL
            export PGDATA=$PWD/pgdata
            export PGPORT=5432
            export PGDATABASE=myapp_development

            # Create PostgreSQL directories if they don't exist
            mkdir -p $PGDATA

            # Initialize the database if it doesn't exist
            if [ ! -d $PGDATA/data ]; then
              initdb -D $PGDATA/data
            fi

            # Create a PostgreSQL superuser
            export PGUSER=my_superuser
            createuser -s $PGUSER || true

            # Create the myapp_development database if it doesn't exist
            psql -U $PGUSER -tc "SELECT 1 FROM pg_database WHERE datname = '$PGDATABASE'" | grep -q 1 || psql -U $PGUSER -c "CREATE DATABASE $PGDATABASE"

            # Start PostgreSQL in the background
            pg_ctl -D $PGDATA/data -l $PGDATA/logfile start

            # Clean up processes on shell exit
            trap "pg_ctl -D $PGDATA/data stop" EXIT
          '';
        };
      }
    );
}