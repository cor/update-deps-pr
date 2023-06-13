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

            runtimeInputs = with pkgs; [ gh coreutils git nix ];

            text = ''
              DATE=$(date --iso-8601)
              echo "$DATE"
              BRANCH="update-deps-$DATE"
              git checkout -b "$BRANCH"
              GIT_LFS_SKIP_SMUDGE=1 nix flake update
              git add -A
              git commit -m "chore: update deps $DATE" -m "Generated using [update-deps-pr](https://github.com/cor/update-deps-pr)"
              git push -u origin "$BRANCH"

              echo -e "Update deps by running \`nix flake update\`\n\n*(This PR is generated using [update-deps-pr](https://github.com/cor/update-deps-pr))*" > git-commit-msg
              MSG=$(cat git-commit-msg)
              export MSG
              gh pr create -t "Update deps ($DATE)" -b "$MSG"
              rm git-commit-msg
            '';
          };
        };
    };
}

