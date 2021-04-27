{
  description = "mbpnix";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
  };

  outputs = { self, stable, unstable, home-manager, utils, nur }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs = {
         input = unstable;
         config = {
           allowUnfree = true;
        };
      };

      hosts = {
        nixos = {
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
            }
             ({ pkgs, ... }: {
              home-manager.users.mbpnix = import ./hm/home.nix;
              environment.shellAliases = {
                nix-repl = "nix repl ${inputs.utils.lib.repl}";
              };
            })
          ];
        };
      };

      sharedOverlays = [
        nur.overlay
      ];

      hostDefaults.modules = [ utils.nixosModules.saneFlakeDefaults ];
    };
}