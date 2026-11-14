{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation {
  pname = "elementary-wallpapers";
  version = "8.0.0-unstable-2026-11-09";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wallpapers";
    rev = "a533370e8e70309b16d34bd1389cd6295310be69";
    hash = "sha256-xa426pGmDjv+5JnCN5uo54sSOviR+1KfWqJz/cXGkoU=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs meson/symlink.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Collection of wallpapers for elementary";
    homepage = "https://github.com/elementary/wallpapers";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
