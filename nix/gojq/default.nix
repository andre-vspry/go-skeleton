{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.7";

  subPackages = [ "cmd/gojq" ];

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    sha256 = "0viv5kr852qssnnf1kw0v5p558h4hsi16nknq0nhi7h50fxln1k9";
    # sha256 = lib.fakeSha256;
  };

  vendorSha256 = "0rw4cqs9bzxk3f0i6lfqc50bwvyxa5hw886wa1kk3iqf0b5x1d3g";
  # vendorSha256 = lib.fakeSha256;

  meta = with lib; {
    description = "Pure Go implementation of jq";
    longDescription = ''
      This is an implementation of jq command written in Go language.
      You can also embed gojq as a library to your Go products.
    '';
    homepage = "https://github.com/itchyny/gojq";
    license = licenses.mit;
    # maintainers = with maintainers; [  ];
  };
}
