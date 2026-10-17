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
  evolution-data-server,
  libadwaita,
  libical,
  libgee,
  libhandy,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-datetime";
  version = "2.4.2-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-datetime";
    rev = "d0b3a703a7efbb5b3040d7be1ccb616eeb919c54";
    sha256 = "sha256-bu4OecFi02yXN1Ui/TTqzy9sD+kj2/QpZ053gdU8hgs=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server
    granite7
    gtk4
    libadwaita
    libgee
    libhandy
    libical
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Date & Time Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-datetime";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
