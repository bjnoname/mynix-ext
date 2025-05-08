{
  description = "My Nix setup";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-2411.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-2411";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv?tag=v1.6";

    wsl.url = "github:nix-community/NixOS-WSL?tag=2411.6.0";
    wsl.inputs.nixpkgs.follows = "nixpkgs-2411";

    nvim-cmp-dotenv.url = "github:SergioRibera/cmp-dotenv";

    rustaceanvim.url = "github:mrcjkb/rustaceanvim";
    rustaceanvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs @ { nixpkgs
    , nixpkgs-2411
    , nixpkgs-unstable
    , sops-nix
    , home-manager
    , nix-index-database
    , wsl
    , ...
    }:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      myusers = import ./config/myusers.nix;
      utils = import ./utils.nix;

      packageMapper = utils.packageMapper (final: prev:
        {
          vimPlugins = { cmp-dotenv = final.nvim-plugin; } // prev.vimPlugins;
        }
      );

      overlays-module = utils.overlaysToModule [
        inputs.nvim-cmp-dotenv.overlays.default
        inputs.rustaceanvim.overlays.default
        (final: prev: {
          inherit (pkgs-unstable) ltex-ls-plus;
          vimPlugins = prev.vimPlugins // { inherit (pkgs-unstable.vimPlugins) nvim-lspconfig; };
        })
      ];

    in
    {

      formatter.${system} = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      devShell.${system} = pkgs.mkShell {
        packages = with pkgs; [
          age
          sops
          ssh-to-age
          nixos-shell
          easyrsa
          deadnix
          nix-tree
        ];
      };

      nixosConfigurations.nixos-wsl = nixpkgs-2411.lib.nixosSystem {

        inherit system;

        modules = [
          ./hosts/common.nix
          ./hosts/nixos-wsl/configuration.nix
          wsl.nixosModules.wsl
          sops-nix.nixosModules.sops
          {
            _module.args = { inherit myusers; };
          }
        ];
      };

      homeConfigurations.jordy = home-manager.lib.homeManagerConfiguration {

        modules = [
          ./home
          overlays-module
          nix-index-database.hmModules.nix-index
          packageMapper
          {
            _module.args = { inherit myusers; };
          }
        ];

        pkgs = import nixpkgs-2411 { inherit system; };
      };
    };
}

