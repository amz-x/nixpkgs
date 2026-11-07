{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  sassc,
  vala,
  glib,
  gtk4,
  libadwaita,
  libgee,
  granite7,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "switchboard";
  version = "8.0.3-unstable-2026-11-04";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard";
    rev = "935bde19ed0a73b41a159508ac9b66c029b2a8df";
    hash = "sha256-o1eaTJmKAL9Td8wVvT5ww5gvoyw3R4obsycoV8Jayg4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    # Required by switchboard-3.pc.
    glib
    granite7
    gtk4
    libadwaita
    libgee
  ];

  patches = [
    # Find plugs through SWITCHBOARD_PLUGS_PATH, set by wrapper.nix, rather
    # than /usr and /usr/local
    ./fix-plugs-path-env.patch
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extensible System Settings app for Pantheon";
    homepage = "https://github.com/elementary/settings";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.settings";
  };
}
