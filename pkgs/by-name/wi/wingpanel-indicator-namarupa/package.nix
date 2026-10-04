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
  version = "0.0.0-unstable-2026-09-13";

  src = fetchFromGitHub {
    owner = "amz-x";
    repo = "wingpanel-indicator-namarupa";
    rev = "199b02fdd0b951344f0835584db56765785c6a50";
    sha256 = "sha256-2WxpsJdhHdF6xO1KTWmn2MqjdW2FUUfe0LMNZ+BqfuA=";
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
