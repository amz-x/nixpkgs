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
  version = "9.0.0-unstable-2026-10-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "maps";
    rev = "04bf3bc67eb050bc95632961b23b2cbad43ae4f2";
    hash = "sha256-8qxoaAvFfAMe9sCX9z80hNY02V3joIG7ELWSFvXuLpY=";
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
