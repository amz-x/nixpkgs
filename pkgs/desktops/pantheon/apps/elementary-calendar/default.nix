{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  evolution-data-server-gtk4,
  folks,
  geoclue2,
  geocode-glib_2,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  libical,
  libportal-gtk4,
  libshumate,
}:

stdenv.mkDerivation {
  pname = "elementary-calendar";
  version = "8.0.2-unstable-2026-11-04";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = "97de059e9ce4ff82e90c322cafba40796b81c64c";
    hash = "sha256-VGcRPj826ta7yLyeF82RwZwAdQVnccrnLSeesUYluoM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    evolution-data-server-gtk4
    folks
    geoclue2
    geocode-glib_2
    granite7
    gtk4
    libadwaita
    libgee
    libical
    libportal-gtk4
    libshumate
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Desktop calendar app designed for elementary OS";
    homepage = "https://github.com/elementary/calendar";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.calendar";
  };
}
