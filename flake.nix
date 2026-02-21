{
  description = "nekoma's system";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkHost = {
      hostname,
      system ? "x86_64-linux",
      user ? "nekoma",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs hostname user;};
        modules = [
          # 1. Load system's modules
          ./modules/system

          # 2. Cấu hình cụ thể của cái máy tính này
          ./hosts/${hostname}/configuration.nix

          # 3. Setup Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs hostname user;};
            home-manager.users.${user} = import ./hosts/${hostname}/home.nix;
          }
        ];
      };
  in {
    nixosConfigurations = {
      # Máy 1: Laptop của bạn
      astral = mkHost {
        hostname = "astral";
      };

      # Máy 2 (Tương lai): Server không màn hình
      # vps-server = mkHost {
      #   hostname = "vps-server";
      # };
    };
  };
}
