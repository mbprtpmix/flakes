{
  description = "mbpnix";

  inputs = {
    stable.url = "github:NixOS/nixpkgs/nixos-20.09";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = { self, stable, unstable, nix-doom-emacs, home-manager, utils, nur }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs = {
        input = unstable;
        config = {
          allowUnfree = true;
        };
      };

      channels.nixpkgs-stable = {
        input = stable;
        config = {
          allowUnfree = true;
        };
      };

      channels.nixpkgs.overlaysBuilder = channels: [
        (final: prev: { inherit (channels) nixpkgs-stable; })
      ];

      hosts = {
        nixos = {
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
            }
             ({ pkgs, ... }: {
              home-manager.users.mbpnix = { ... }: { imports = [ nix-doom-emacs.hmModule ./home/home.nix ]; };
              environment.shellAliases = {
                ll = "exa --color=always --icons -al --group-directories-first";
                ls = "exa --color=always --icons -l --group-directories-first";
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
