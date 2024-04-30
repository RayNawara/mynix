{
    description = "Initial flake.";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home_manager.url = "github:nix-community/home-manager/master";
        home_manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    # The output is your built and working system configuration
    outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    in {
        nixosConfigurations = {
            nixos = lib.nixosSystem {
                inherit system;
                specialArgs = {inherit inputs;};
                modules = [ ./configuration.nix ];
            };
        };
        homeConfigurations = {
            ray = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${system};
                extraSpecialArgs = {inherit inputs;};
                modules = [ ./home.nix ];
            };
        };
    };
}