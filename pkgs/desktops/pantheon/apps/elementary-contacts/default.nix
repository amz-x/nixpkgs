{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  folks,
  glib,
  granite7,
  gtk4,
  libadwaita,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-contacts";
  version = "0-unstable-2026-11-21";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "contacts";
    rev = "50febe39ff33bbe7b47276cc8e92300d300866bc";
    hash = "sha256-zkDWpqSg9Ws1ZL00ntKOS8ELtjSdiy4w8qks751t8lM=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    folks
    glib
    granite7
    gtk4
    libadwaita
    wayland
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "See and get in touch with your contacts";
    homepage = "https://github.com/elementary/contacts";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.contacts";
  };
})
