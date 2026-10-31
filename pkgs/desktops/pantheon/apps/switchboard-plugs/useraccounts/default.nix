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
  version = "8.0.1-unstable-2026-10-26"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-useraccounts";
    rev = "522873a5fd0627d595d65119d9d73eae6c68fbc4";
    hash = "sha256-tFRH2/or3gfO9SxW2Pu6IHoOu6CKmiKXywcefWHWWXE=";
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
