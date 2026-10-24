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
    rev = "9c4dae670768e1c4617e5bde3a223fa45aabb583";
    hash = "sha256-aLjIqJylpBk3YAS0oQYwtMgYukJKmlQg+gG7LnRoCnw=";
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
