{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  accountsservice,
  libadwaita,
  libgee,
  libpwquality,
  gettext,
  gnome-desktop,
  granite7,
  gtk4,
  glib,
  polkit,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-useraccounts";
  version = "8.0.1-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-useraccounts";
    rev = "abd23276d1bde1f7a7d30137dfb6258fe92a2d39";
    hash = "sha256-j8DlxH69HFY2DDZRzMiU0N5MmVZ5zLuLL9Ljx22n93k=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    accountsservice
    glib
    gnome-desktop
    granite7
    gtk4
    libadwaita
    libgee
    libpwquality
    polkit
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard User Accounts Settings";
    homepage = "https://github.com/elementary/settings-useraccounts";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
