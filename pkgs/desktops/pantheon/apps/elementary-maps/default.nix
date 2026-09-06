{
  stdenv,
  lib,
  fetchFromGitHub,
  glib,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  geoclue2,
  geocode-glib_2,
  granite7,
  gtk4,
  libadwaita,
  libshumate,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-maps";
  version = "8.1.0-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "maps";
    rev = "bdd2777be4e1a168b7284320d6a635daef2880b1";
    hash = "sha256-x83o4Q/MlVjAAFpo5Yja0hqavbk0nwOr93qwqBu58sQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    geoclue2
    geocode-glib_2
    glib
    granite7
    gtk4
    libadwaita
    libshumate
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/maps";
    description = "Map viewer designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.maps";
  };
})
