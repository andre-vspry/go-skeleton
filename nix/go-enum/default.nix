{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-enum";
  version = "0.3.11";

  src = fetchFromGitHub {
    owner = "abice";
    repo = "go-enum";
    rev = "v${version}";
    # sha256 = lib.fakeSha256;
    sha256 = "1jwg4gfb3sfq7yz32zkc0a2225fixgmpl3k4rwxzvk0qdmm6gfgl";
  };

  vendorSha256 = "1d1fvlp58d3fz26a3g3a57hkczdz0qjwyzr1xx2vnpspkn3wzqgj";
  # vendorSha256 = lib.fakeSha256;
}
