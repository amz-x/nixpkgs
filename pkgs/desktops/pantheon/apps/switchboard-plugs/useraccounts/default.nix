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
  version = "8.0.1-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-useraccounts";
    rev = "f71056ec21dfea751a54a5f8fe1ecf5d9ea1971c";
    hash = "sha256-U5r/hLWgZoTc7wS0SDwA+A19jQWzqD35Jcv2VYQSF40=";
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
