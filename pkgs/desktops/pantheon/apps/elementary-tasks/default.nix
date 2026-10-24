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
  clutter-gtk,
  evolution-data-server,
  granite7,
  geoclue2,
  geocode-glib_2,
  gtk4,
  libadwaita,
  libchamplain_libsoup3,
  libgee,
  libhandy,
  libical,
  libportal-gtk4,
  libshumate,
}:

stdenv.mkDerivation {
  pname = "elementary-tasks";
  version = "6.3.3-unstable-2026-10-14"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "tasks";
    rev = "1509007edfb932d60086ce4f4f14afe09440d6a0";
    hash = "sha256-/smb0V9TneUszsqvdFU9Iruu4KkXdnqG99zkkEwWfUw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    clutter-gtk
    evolution-data-server
    granite7
    geoclue2
    geocode-glib_2
    gtk4
    libadwaita
    libchamplain_libsoup3
    libgee
    libhandy
    libical
    libportal-gtk4
    libshumate
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/tasks";
    description = "Synced tasks and reminders on elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.tasks";
  };
}
