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
  version = "8.1.2-unstable-2026-11-21";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "notifications";
    rev = "55ca0cef82f3054fdc29eaa72aea331d9295561c";
    hash = "sha256-nmxgZTfkj3xpHq0/nLLu8Q0+813v4Vb0LzoRsnEHeQY=";
  };

  patches = [
    # Close button icon inherits the dark .osd fg in dark mode on a black background
    ./fix-close-button-dark-icon.patch
  ];

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
