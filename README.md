# PIE devShells

Nix devShells that mirror the tools available on the PIE

## Available shells

- [`ing1`](./ing1.nix) (core PIE packages + nixos-pie specific packages except podman)
- [`spe`](./spe.nix) (core PIE packages + nixos-spe specific packages)
- [`sup`](./sup.nix) (core PIE packages + nixos-sup specific packages)

## Usage

To enter one of the development shells listed above, call `nix develop '.#<shell
name>'`. For example, to enter a development shell with the same tools as the
nixos-sup PIE image:

```console
$ nix develop '.#sup'
bash 5.1$
```

The default devShell is `ing1`, so calling `nix develop` will enter the
`nixos-pie`-like environment by default.

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
