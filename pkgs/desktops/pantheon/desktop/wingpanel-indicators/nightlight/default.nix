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
  libgee,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-nightlight";
  version = "2.1.3-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-nightlight";
    rev = "fbe5a2a988da1240a4514908d649fd8e1899f097";
    sha256 = "sha256-v5pANOCyorm7peioI4FbQvs+LVrszpWOJlECiyz/saA=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libgee
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Night Light Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-nightlight";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
