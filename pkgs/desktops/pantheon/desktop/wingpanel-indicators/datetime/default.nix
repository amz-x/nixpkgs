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
  version = "2.4.2-unstable-2026-07-27"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-datetime";
    rev = "7f17fda9f42b71d3c30977deaf3fbe6273e59dad";
    sha256 = "sha256-azp/+c9CbF7/1OAXqFT3o5zVq5HMCE6sCtquQfF5710=";
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
