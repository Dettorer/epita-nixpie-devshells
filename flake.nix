{
  description = ''
    This flake defines a devshell that pulls a subset of the exact same packages
    as EPITA's "nixos-pie" image (the development tools for the lessons I give).
  '';

  inputs = {
    nixpie.url = "git+https://gitlab.cri.epita.fr/cri/infrastructure/nixpie";
    nixpkgs.follows = "nixpie/nixpkgs";
  };

  outputs = { self, nixpie, nixpkgs, ... }:
  let
    inherit (nixpkgs) lib;

    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ nixpie.overlay ];
    };

    # A module that defines a minimal set of options and module arguments used
    # by the minimal nixos configuration defined below (options used by the
    # `cri.packages.pkgs.*` modules)
    mockNixosConfigModule = { lib, ... }: {
      # Give `pkgs` as an argument to the modules of our minimal
      # nixosConfiguration
      config._module.args = {
        inherit pkgs;
      };

      # Define the attribute sets used by nixpie modules
      options = {
        # For modules that use `environment.systemPackages`
        environment = lib.mkOption {
          type = lib.types.attrs;
        };
        # For modules that use `programs.*.enable`
        programs = lib.mkOption {
          type = lib.types.attrs;
        };
        # For modules that use `virtualisation.*`. Currently this is only the
        # case for the podman module, which we don't enable, but the option
        # still needs to be defined in order to evaluate the whole configuration
        virtualisation = lib.mkOption {
          type = lib.types.attrs;
        };
      };
    };

    #######################################################################
    ### THIS IS WHERE THE REAL PERSONALISATION IS, THE REST IS PLUMBING ###
    #######################################################################
    # A module that enables the nixpie modules whose packages we want in our
    # devShell.
    nixpieWantedModules = {
      cri.packages.pkgs = {
        core.enable = true;
        dev.enable = true;
        asm.enable = true;
        thl.enable = true;
        tiger.enable = true;
      };
    };

    # A minimal nixosConfiguration, built using the above modules, whose
    # systemPackages list contains what we want for our devShell
    minimalNixpieImage = lib.evalModules {
      modules = [
        nixpie.nixosModules.packages
        mockNixosConfigModule
        nixpieWantedModules
      ];
    };

    # `clang-tools` needs to be included before `clang` because they both
    # expose a `clangd` binary (and other tools from the clang family), but
    # the version from the `clang` package is broken (not wrapped for nix or
    # something like that).
    nixosPiePackages = [ pkgs.clang-tools ] ++ minimalNixpieImage.config.environment.systemPackages;
  in
  {
    devShells.x86_64-linux.ing1 = pkgs.mkShell {
      buildInputs = nixosPiePackages;
    };

    # Default shell used when calling `nix develop` with no other argument
    devShell.x86_64-linux = self.devShells.x86_64-linux.ing1;
  };
}
