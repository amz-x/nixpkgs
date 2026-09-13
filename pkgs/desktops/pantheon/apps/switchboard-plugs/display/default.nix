{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  gettext,
  glib,
  granite7,
  gtk4,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-display";
  version = "8.0.3-unstable-2026-08-18";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-display";
    rev = "9e50d866482b7fecd29db3c8654ef74b32dd532b";
    sha256 = "sha256-GbIJjcV10BYaOb5yv4Kos6qJCjmvzFiraGYj/yhU9Gc=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/settings-display";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
