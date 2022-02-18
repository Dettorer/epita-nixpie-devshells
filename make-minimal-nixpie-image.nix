{
  nixpie,
  pkgs,
}:

let
  inherit (pkgs) lib;

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
      # For modules that use `environment`, most importantly
      # `environment.systemPackages`
      environment = {
        sessionVariables = lib.mkOption {
          type = lib.types.attrs;
        };
        systemPackages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [];
        };
        variables = lib.mkOption {
          type = lib.types.attrs;
        };
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
in
  shellDescription: {
    name = shellDescription.shellName;
    value = lib.evalModules {
      modules = [
        nixpie.nixosModules.packages
        mockNixosConfigModule
        shellDescription.wantedModules
      ];
    };
  }
