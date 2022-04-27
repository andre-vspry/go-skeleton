{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jwt";
  version = "4.3.0";

  subPackages = [ "cmd/jwt" ];

  src = fetchFromGitHub {
    owner = "golang-jwt";
    repo = "jwt";
    rev = "v${version}";
    # sha256 = lib.fakeSha256;
    sha256 = "1xkc89ya78wzmiraxlfqfk630dygf0g06bkrdwg0nzbxm258fcy6";
  };

  vendorSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
  # vendorSha256 = lib.fakeSha256;
}
