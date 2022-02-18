{
  # Name of the devShell as a flake output
  shellName = "ing1";

  # Shopping list from
  # https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/tree/master/modules/packages/pkgs
  wantedModules = {
    cri.packages.pkgs = {
      core.enable = true;
      dev.enable = true;
      thl.enable = true;
      tiger.enable = true;
    };
  };
}
