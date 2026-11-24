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
  version = "8.0.0-unstable-2026-11-17";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wallpapers";
    rev = "e5d614c1ad9190c2b2568f88ee9614a787c686ed";
    hash = "sha256-Cm8tKjOqphTEuB1pDGDKnPdAmAo6yzxJ00qVHSTdpn0=";
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
