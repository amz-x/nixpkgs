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
  networkmanager,
  polkit,
  libnma-gtk4,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-network";
  version = "8.0.1-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-network";
    rev = "8685ec8e55a45e48da0c12931a353cd440d11664";
    hash = "sha256-BCGrVjfBUh+5ryvY32EipxgUgnEQXbdZawYT89zobGY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libgee
    networkmanager
    polkit
    libnma-gtk4
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Network Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-network";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
