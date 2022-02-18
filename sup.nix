{
  # Name of the devShell as a flake output
  shellName = "sup";

  # Shopping list from
  # https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/tree/master/modules/packages/pkgs
  wantedModules = {
    cri.packages.pkgs = {
      afit.enable = true;
      core.enable = true;
      csharp.enable = true;
      dev.enable = true;
      ocaml.enable = true;
    };
  };
}
