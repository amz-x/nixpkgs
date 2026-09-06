{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  granite7,
  wingpanel,
  libadwaita,
  libgee,
  libhandy,
  elementary-notifications,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-notifications";
  version = "7.1.1-unstable-2026-09-05"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-notifications";
    rev = "13dce9b8a96dd95c0b185f5324cc2ac1fd947eec";
    sha256 = "sha256-ggngiGbEWKoIp3JHhFWpo/0gaYJVTThzWMUmt0AXonw=";
  };

  nativeBuildInputs = [
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
    libhandy
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Notifications Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-notifications";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
