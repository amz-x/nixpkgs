{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  libadwaita,
  libgee,
  granite7,
  gexiv2_0_10,
  gnome-settings-daemon,
  elementary-settings-daemon,
  gtk4,
  gala,
  wingpanel,
  wingpanel-indicator-keyboard,
  wingpanel-quick-settings,
  switchboard,
  gettext,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-pantheon-shell";
  version = "8.3.0-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-desktop";
    rev = "5c4b6bedf794a75d7dcd5bf7dae318661376a607";
    hash = "sha256-o+4IszOKewJm1UyFtx2mhtVw3yjfAQU6deeQ9Lu0W4o=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    gala
    gexiv2_0_10
    glib
    gnome-settings-daemon
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel
    wingpanel-indicator-keyboard # gsettings schemas
    wingpanel-quick-settings # gsettings schemas
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Desktop Plug";
    homepage = "https://github.com/elementary/settings-desktop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
