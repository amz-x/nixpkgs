{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  glib,
  granite7,
  libadwaita,
  libcanberra,
  wayland-scanner,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "elementary-notifications";
  version = "8.1.2-unstable-2026-09-03"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = "eb053af2fb70aadfd2c21e5b668baa7fa3ec6884";
    hash = "sha256-1mkcq6oSO19oC9vxxIzcL+epBa/pjsA/yAHr3h0KjnU=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    libcanberra
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GTK notification server for Pantheon";
    homepage = "https://github.com/elementary/notifications";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "io.elementary.notifications";
  };
}
