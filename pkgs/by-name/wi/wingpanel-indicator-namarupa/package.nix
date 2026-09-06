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
  version = "0.0.0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "amz-x";
    repo = "wingpanel-indicator-namarupa";
    rev = "b85c07ce8be3482576811e6a9aefb4dc3337dcaa";
    sha256 = "sha256-L9PNpuFDTEAewx39ngIJ+es732T0HHh/46yMkblkfV8=";
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
