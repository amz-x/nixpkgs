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
  version = "8.0.0-unstable-2026-10-03"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wallpapers";
    rev = "ad7021aa284790f3c5c0f002ec5869713ca78c1a";
    hash = "sha256-gxxR+icle7lMlivtRkNle0nnHC5ke9jt2JcaqG5PsEs=";
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
