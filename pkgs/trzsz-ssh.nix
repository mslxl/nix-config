{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "trzsz-ssh";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "trzsz";
    repo = "trzsz-ssh";
    rev = "v${version}";
    hash = "sha256-VvPdWRP+lrhho+Bk5rT9pktEvKe01512WoDfAu5d868=";
  };

  vendorHash = "sha256-EllXxDyWI4Dy5E6KnzYFxuYDQcdk9+01v5svpARZU44=";

  meta = with lib; {
    description = "An alternative to ssh client, offers additional useful features";
    homepage = "https://github.com/trzsz/trzsz-ssh";
    license = licenses.mit;
    mainProgram = "tssh";
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
  };
}
