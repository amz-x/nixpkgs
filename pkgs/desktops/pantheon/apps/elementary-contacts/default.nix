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
  version = "0.0.0-unstable-2026-08-17"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "contacts";
    rev = "ec4de391bba8e59feef495bef2031e2b38c6a0f0";
    hash = "sha256-uoBWso32y+m/cSfDZl0CGYSFc81a/p0FurpVgrhP32o=";
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
