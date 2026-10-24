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
    rev = "3116dfce42380f1c254f996fb07e82e3044c57fd";
    hash = "sha256-n5Bp1fsIJb3GDzHAZFeQbjt9FEDEDmIXHzKT3KKoRxE=";
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
