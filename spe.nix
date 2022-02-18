{
  # Name of the devShell as a flake output
  shellName = "spe";

  # Shopping list from
  # https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/tree/master/modules/packages/pkgs
  wantedModules = {
    cri.packages.pkgs = {
      asm.enable = true;
      core.enable = true;
      dev.enable = true;
      gtk.enable = true;
      rust.enable = true;
      sdl.enable = true;
      thl.enable = true;
    };
  };
}
