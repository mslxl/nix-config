{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "trzsz-go";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-go";
    rev = "v${version}";
    hash = "sha256-g1fbgKTFS9aPAmnTeFYoymrDEoZ6BtzUhA2Z9SNYbsU=";
  };

  vendorHash = "sha256-AsrRHHBlzW5s/PtJSQ+hAgqUIYwDwoemQaerRV/QKX0=";

  meta = with lib; {
    description = "Makes all terminals that support local shell to support trzsz";
    homepage = "https://github.com/trzsz/trzsz-go";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
