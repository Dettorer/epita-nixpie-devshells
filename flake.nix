{
  description = ''
    This flake defines some devShells that pull minimal sets of the exact same
    packages as EPITA's PIE images (development tools for different lessons).
  '';

  inputs = {
    nixpie.url = "git+https://gitlab.cri.epita.fr/cri/infrastructure/nixpie";
    nixpkgs.follows = "nixpie/nixpkgs";
  };

  outputs = { self, nixpie, nixpkgs, ... }:
  let
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [ nixpie.overlay ];
    };
    inherit (pkgs) lib;

    mkMinimalNixpieImage = import ./make-minimal-nixpie-image.nix {
      inherit nixpie pkgs;
    };

    minimalNixpieImages = builtins.listToAttrs (lib.forEach
      (import ./shells.nix)
      (descPath: mkMinimalNixpieImage (import descPath))
    );

    mkShellFromeImage = name: value: let
      piePackages = value.config.environment.systemPackages;
    in pkgs.mkShell {
      # `clang-tools` needs to be included before `clang` because they both
      # expose a `clangd` binary (and other tools from the clang family), but
      # the version from the `clang` package is broken (not wrapped for nix or
      # something like that).
      buildInputs = [ pkgs.clang-tools ] ++ piePackages;
    };
  in
  {
    devShells.x86_64-linux = builtins.mapAttrs mkShellFromeImage minimalNixpieImages;

    # Default shell used when calling `nix develop` with no other argument
    devShell.x86_64-linux = self.devShells.x86_64-linux.ing1;
  };
}
