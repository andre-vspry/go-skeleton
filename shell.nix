{ pkgs ? import <nixpkgs> { }, unstable ? import <unstable> { } }:
let
  go = pkgs.go_1_18;
  nix-pre-commit-hooks =
    import (builtins.fetchGit "https://github.com/cachix/pre-commit-hooks.nix");
  pre-commit-golang = pkgs.callPackage ({ stdenv, fetchFromGitHub }:
    stdenv.mkDerivation rec {
      pname = "pre-commit-golang";
      version = "0.5.0-96221dc";
      src = fetchFromGitHub {
        owner = "dnephin";
        repo = pname;
        rev = "96221dc741cb30cc0136999083dc6bd0e2113000";
        sha256 = "sha256-lIQBoT+UIlVGnFaaGBgXag0Lm1UhGj/pIGlCCz91L4I=";
      };
      dontBuild = true;
      dontConfigure = true;
      installPhase = ''
        runHook preInstall
        install -d $out
        find . -type f -name 'run-*.sh' \
        | sed -E 's:^\./run-(.*)\.sh:\1:' \
        | xargs -I {} install ./run-{}.sh $out/{}
        runHook postInstall
      '';
    }) { };
  pre-commit-golang-hook = name: {
    "${name}" = {
      inherit name;
      enable = true;
      entry = "${pre-commit-golang}/${name}";
      files = "\\.go$";
    };
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
      go-outline
      go-bindata
      golangci-lint
      gofumpt
      go-jwt
      go-enum
      openssl
      jq
      gojq
      nixfmt
      rnix-lsp
      shellcheck
      google-cloud-sdk
      # skaffold minikube kubectl
      sonar-scanner-cli
    ] ++ (with unstable; [ ]);
  shellHook = ({
    pre-commit-check = nix-pre-commit-hooks.run {
      src = ./.;
      # If your hooks are intrusive, avoid running on each commit with a default_states like this:
      # default_stages = ["manual" "push"];
      hooks = {
        terraform-format.enable = true;
        shellcheck.enable = true;
        nix-linter.enable = true;
        nixfmt.enable = true;
      } // (pre-commit-golang-hook "golangci-lint")
        // (pre-commit-golang-hook "go-fmt")
        // (pre-commit-golang-hook "go-mod-tidy")
        // (pre-commit-golang-hook "go-imports");
    };
  }).pre-commit-check.shellHook;
}

# - id: go-fmt
# - id: golangci-lint
# - id: go-mod-tidy
# - id: go-imports
# - id: validate-toml
# - id: go-unit-tests
