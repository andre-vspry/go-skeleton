{ pkgs ? import <nixpkgs> { }
, unstable ? import <unstable> { }
}:
let
  go-jwt = unstable.callPackage ./nix/go-jwt {};
  go-enum = unstable.callPackage ./nix/go-enum {};
  go-tools = unstable.callPackage ./nix/go-tools {};
  gojg = unstable.callPackage ./nix/gojq {};
  # gqlgen = unstable.callPackage ./nix/gqlgen {}; # Uses plugins which are not working
  # just run `go run github.com/99designs/gqlgen@latest`
in
pkgs.mkShell {
  packages = with pkgs; [
  ] ++ (with unstable; [
    go gopls gopkgs gotests gomodifytags impl go-tools delve goplay goreleaser go-mockery go-outline go-bindata golangci-lint gofumpt
    go-jwt
    go-enum
    openssl
    jq gojq
    nixfmt rnix-lsp
    shellcheck
    google-cloud-sdk
    # skaffold minikube kubectl
    sonar-scanner-cli
  ]);
}
