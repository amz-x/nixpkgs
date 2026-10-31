{
  lib,
  fetchFromGitHub,
  stdenv,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk4,
  libgee,
  pantheon,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-namarupa";
  version = "0-unstable-2026-10-28"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "amz-x";
    repo = "wingpanel-indicator-namarupa";
    rev = "eed9f96f9c1ec5b7f6d1f3cf21f1a9e65bd5421d";
    sha256 = "sha256-UP9hJmtnRVZCdi5dR3xwd1ngQlIQbwC0R3fILI5WNa8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gtk4
    libgee
    pantheon.granite7
    pantheon.wingpanel
  ];

  meta = {
    description = "Wingpanel indicator that shows StatusNotifierItem (ayatana/appindicator) tray icons";
    homepage = "https://github.com/amz-x/wingpanel-indicator-namarupa";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
