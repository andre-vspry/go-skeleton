{ pkgs ? import <nixpkgs> { }, unstable ? import <unstable> { } }:
let
  go = pkgs.go_1_18;
  nix-pre-commit-hooks =
    import (builtins.fetchGit "https://github.com/cachix/pre-commit-hooks.nix");
  pre-commit-golang-hook = name: {
    inherit name;
    enable = true;
    entry = "${pkgs.pre-commit-golang}/${name}";
    files = "\\.go$";
  };

  # gqlgen = unstable.callPackage ./nix/gqlgen {}; # Uses plugins which are not working
  # just run `go run github.com/99designs/gqlgen@latest`
in pkgs.mkShell {
  packages = with pkgs;
    [
      go
      gopls
      gopkgs
      gotests
      gomodifytags
      impl
      go-tools
      gotools
      delve
      goplay
      goreleaser
      go-mockery
      go-outliner
      go-bindata
      golangci-lint
      gofumpt
      go-jwt
      go-enum
      oapi-codegen
      openssl
      oauth2l
      gin
      cloudsql-proxy
      cachecmd
      mailslurper
      ifacemaker
      jq
      gojq
      nixfmt
      rnix-lsp
      shellcheck
      google-cloud-sdk
      # skaffold minikube kubectl
      sonar-scanner-cli
      nodePackages.markdownlint-cli
    ] ++ (with unstable; [ ]);
  shellHook = ({
    pre-commit-check = nix-pre-commit-hooks.run {
      src = ./.;
      # If your hooks are intrusive, avoid running on each commit with a default_states like this:
      # default_stages = ["manual" "push"];
      hooks = {
        markdownlint.enable = true;
        terraform-format.enable = true;
        shellcheck.enable = true;
        nix-linter.enable = true;
        nixfmt.enable = true;
        golangci-lint = (pre-commit-golang-hook "golangci-lint") // {
          pass_filenames = false;
        };
        go-fmt = pre-commit-golang-hook "go-fmt";
        go-mod-tidy = pre-commit-golang-hook "go-mod-tidy";
        go-imports = pre-commit-golang-hook "go-imports";
        go-unit-tests = pre-commit-golang-hook "go-unit-tests";
      };
    };
  }).pre-commit-check.shellHook;
}

# - id: validate-toml
# - id: go-unit-tests
