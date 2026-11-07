{
  lib,
  stdenv,
  desktop-file-utils,
  nix-update-script,
  fetchFromGitHub,
  flatpak,
  gettext,
  glib,
  granite7,
  gtk4,
  meson,
  ninja,
  pkg-config,
  vala,
  libxml2,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "sideload";
  version = "6.3.1-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sideload";
    rev = "728c5ef29828fbe68675f8fedb762d8288ae647f";
    hash = "sha256-6624WDFk/34+YyA+XTJGunWDbuds2kA8GxC7wZeZmE0=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    granite7
    gtk4
    libxml2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/sideload";
    description = "Flatpak installer, designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.sideload";
  };
}
