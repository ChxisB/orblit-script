# Contributing

The Orblit scripting runtime.

Talk about anything large first, in an issue or on the
[Discord](https://discord.gg/5DH7HuDUtJ). Small fixes need no ceremony — open
the pull request. The engine itself lives in
[ChxisB/orblit](https://github.com/ChxisB/orblit), and its
[CONTRIBUTING](https://github.com/ChxisB/orblit/blob/main/CONTRIBUTING.md) has
the fuller version of this.

## Checking your work

Initialise the QuickJS submodule first — a fresh clone will not build without
it, and the failure does not say so clearly:

```sh
git submodule update --init --recursive
./tool/check.sh
./tool/check_typings.sh
```

## Licence

This repository is under MPL-2.0. Opening a pull request means you are
offering your change under that same licence, and that you wrote it or
otherwise have the right to contribute it.

There is no CLA to sign and no copyright to assign. You keep the copyright on
what you write; it is simply licensed the same way as the rest of the
repository.
