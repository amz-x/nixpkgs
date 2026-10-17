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
  version = "7.1.1-unstable-2026-10-06"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-notifications";
    rev = "033715d6375f62a15cad3edc0829a312a1d78f9b";
    hash = "sha256-++WoKvGDoIkLN+oh5AN9aFnxXXFa4Ucb8kop0S3zUGg=";
  };

  patches = [
    # The indicator icon state is only updated when the notification list or
    # do-not-disturb setting changes, so DND enabled at startup shows the
    # normal bell. Set the initial state when the display widget is created,
    # and defer it until the svg is playing so the faded look animates in.
    ./fix-initial-dnd-icon.patch
  ];

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
