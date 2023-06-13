# update-deps-pr
A simple tool to run `nix flake update` and open a PR

## How to use

1. Go to the repo for which you want to update the flake's dependencies.
2. Checkout `main` and ensure that your working directory is clean.
3. `nix run "github:cor/update-deps-pr"`
