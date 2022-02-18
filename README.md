# PIE devShells

Nix devShells that mirror the tools available on the PIE

## Usage

Only one devShell is available now, which mirrors the "nixos-pie" image (image
used by ING1 students) with core, dev, asm, thl and tiger package bundles. To
use it, call `nix develop`:

```console
$ nix develop '.#ing1'
bash 5.1$
```

Or, since it's the current default devShell:

```console
$ nix develop
bash 5.1$
```

## Direnv

I suggest installing
[`nix-direnv`](https://github.com/nix-community/nix-direnv), then cloning this
repository anywhere on your computer, then creating a `.envrc` file in the work
directory where you want the PIE tools available that points to the cloned
flake. For example:

```console
$ cd ~/work/epita/
$ git clone git@gitlab.cri.epita.fr:paul.hervot/pie-devshells.git
[...]
$ cd ~/work/epita/ing1
$ echo "use flake ../pie-devshells#ing1" > .envrc
$ direnv allow
direnv: loading ~/work/epita/ING1/.envrc
direnv: using flake ../pie-devshells#ing1
[...]
```

After that, the ING1 devShell will start each time you enter that work
directory.

Maybe using a flake registry is an even better idea but I haven't learned how to
use that yet!
