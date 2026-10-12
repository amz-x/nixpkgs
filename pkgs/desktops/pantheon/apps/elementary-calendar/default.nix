{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook3,
  clutter,
  evolution-data-server,
  folks,
  geoclue2,
  geocode-glib_2,
  granite,
  gtk3,
  libchamplain_libsoup3,
  libgee,
  libhandy,
  libical,
  libportal-gtk3,
}:

stdenv.mkDerivation {
  pname = "elementary-calendar";
  version = "8.0.2-unstable-2026-08-14"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calendar";
    rev = "42393174960f8c4d88260e51e4a086d1c5f9c19f";
    hash = "sha256-z/GKp2paaoLRnX6Prbvj/bcrsui/pxxi13Lm2FN7bMo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    clutter
    evolution-data-server
    folks
    geoclue2
    geocode-glib_2
    granite
    gtk3
    libchamplain_libsoup3
    libgee
    libhandy
    libical
    libportal-gtk3
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
