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
  version = "8.1.0-unstable-2026-10-08"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "maps";
    rev = "97bfd674d9eab56c3ada9a5f81ba0f525648f862";
    hash = "sha256-DHgLJepL5WTinwl2kRleKVJoxNl6kOssNBUx8lI27fQ=";
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
