{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  granite7,
  gtk4,
  switchboard,
  flatpak,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-applications";
  version = "8.3.0-unstable-2026-11-04";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-applications";
    rev = "f64ba8065036d9d8bae5ae8762caee349ebfc81d";
    hash = "sha256-+QBFuIgEljkoY9cMXJ5HPr86HAzyB6fQYfoW4hL0Qtk=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    flatpak
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
    description = "Switchboard Applications Plug";
    homepage = "https://github.com/elementary/settings-applications";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
