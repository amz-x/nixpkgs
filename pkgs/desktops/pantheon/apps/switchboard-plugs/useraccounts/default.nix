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
  version = "8.0.1-unstable-2026-07-25"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-useraccounts";
    rev = "a3cf79c45521717bb10b0cd73548395bd653e8b4";
    hash = "sha256-q+GPoq+USV1mLl6CpVH7a7j5iVzJ3vdE6b5+0SyM8No=";
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
