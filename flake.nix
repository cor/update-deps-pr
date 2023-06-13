{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, treefmt, system, lib, ... }:
        {
          packages.default = pkgs.writeShellApplication {
            name = "update-deps-pr";

            runtimeInputs = with pkgs; [ gh coreutils ];

            text = ''
              DATE=$(date --iso-8601)
              echo "$DATE"
              BRANCH="update-deps-$DATE"
              git checkout -b "$BRANCH"
              nix flake update
              git add -A
              git commit -m "chore: update deps $DATE"
              git push -u origin "$BRANCH"
              gh pr create -t "Update deps ($DATE)" -b "Update deps by running \`nix flake update\`"
            '';
          };
        };
    };
}

