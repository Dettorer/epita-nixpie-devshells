{
  # Name of the devShell as a flake output
  shellName = "sup";

  # Shopping list from
  # https://gitlab.cri.epita.fr/cri/infrastructure/nixpie/-/tree/master/modules/packages/pkgs
  wantedModules = {
    cri.packages.pkgs = {
      dev.enable = true;
      ocaml.enable = true;
      afit.enable = true;
      csharp.enable = true;
    };
  };
}
