{
  lib,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.0.0-unstable-2026-09-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "amz-x";
    repo = "wingpanel-indicator-namarupa";
    rev = "d3b197bc31c1ef7b6c2f1a2b52e1904bbd67b04a";
    sha256 = "sha256-DrJ5ot7ultpVlMvdv6aJDP+IfUd++YLccI24sfXUgQ0=";
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
