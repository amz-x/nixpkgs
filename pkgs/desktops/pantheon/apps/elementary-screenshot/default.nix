{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  gdk-pixbuf,
  glib,
  granite7,
  gtk4,
  libportal,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "elementary-screenshot";
  version = "9.0.0-unstable-2026-11-21";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "screenshot";
    rev = "7fdb2fb264e6a4d83f7f65d21bed7faccfd55fb9";
    hash = "sha256-m4jhLNaSUWy92sSokq0yDj3k04XPGw6maV1Rj+qGRbM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    glib
    granite7
    gtk4
    libportal
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Screenshot tool designed for elementary OS";
    homepage = "https://github.com/elementary/screenshot";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.screenshot";
  };
}
