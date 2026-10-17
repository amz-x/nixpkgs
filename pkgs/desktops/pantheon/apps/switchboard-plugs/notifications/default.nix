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
  elementary-notifications,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-notifications";
  version = "8.0.1-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-notifications";
    rev = "3a289a7adfbc56608cc96c39e1cb1fd4a176ec2b";
    hash = "sha256-oc/GKzobXE+XFgM/oNMV5dEUSPbDztC7MHMhwkLJZFA=";
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
    elementary-notifications
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
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/settings-notifications";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
