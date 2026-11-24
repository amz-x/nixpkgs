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
  version = "8.3.0-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-applications";
    rev = "a8db1fe5898321a81eddc18d1bbf92ed1f08ccf6";
    hash = "sha256-xNfrN3c5vO0HGDx8OA21PllUmLkTCs47VyWDJvP0X3M=";
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
