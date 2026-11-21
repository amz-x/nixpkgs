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
  version = "8.0.1-unstable-2026-11-02";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-useraccounts";
    rev = "502a91570fe2719a2ee7f50001a68aeb07554f01";
    hash = "sha256-vsFjvcE+m4MTXX3wPRGqzSt6brlZ67q8pqv42o7YF34=";
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
