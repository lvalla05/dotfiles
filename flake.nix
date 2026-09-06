{
  description = "dotfiles: Likhith's Mac, declared";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Homebrew itself is pinned here, not by nix-homebrew's own lock: the
    # blender cask needs the command_wrapper stanza that shipped in Homebrew
    # 6.0.13. Bump this tag to move Homebrew, then `nix flake lock` and
    # ./rebuild.sh.
    brew-src = {
      url = "github:Homebrew/brew/6.0.21";
      flake = false;
    };
    nix-homebrew.inputs.brew-src.follows = "brew-src";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs, ... }:
    let
      # The one username line to change if this isn't your machine.
      # bootstrap.sh offers to rewrite this for you if your macOS username differs.
      user = "likhithvalla";
    in
    {
      # bootstrap.sh uses this app so the first privileged darwin-rebuild comes
      # from the exact nix-darwin revision in flake.lock.
      apps.aarch64-darwin.darwin-rebuild = {
        type = "app";
        program = "${nix-darwin.packages.aarch64-darwin.darwin-rebuild}/bin/darwin-rebuild";
      };

      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # A pre-existing regular file at a managed path is moved aside as
            # *.backup instead of failing the switch, and a stale *.backup from
            # an earlier switch is overwritten instead of aborting with
            # "would be clobbered" (the second most common rebuild failure).
            home-manager.backupFileExtension = "backup";
            home-manager.overwriteBackup = true;
            home-manager.extraSpecialArgs = { inherit user; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
    };
}
