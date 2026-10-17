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
    rev = "a0e99f5143121b303c61f83d8d997fea19c2e38c";
    hash = "sha256-wXfW83gQ52suBLYoxDHNWOR+p48HWBD1OtDMfX4CtuU=";
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
