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
  granite7,
  gtk4,
  cups,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-printers";
  version = "8.0.2-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-printers";
    rev = "5e910ce492e03286badf0036dbd255282e599fb2";
    hash = "sha256-9c0bfDeUtUic5RHRiFgWLr9pAnNIwYNQI5b2hHaC9Go=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
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
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/settings-printers";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
