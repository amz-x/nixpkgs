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
  version = "7.1.1-unstable-2026-10-20"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-notifications";
    rev = "a448f173dfed86478944d4a03002b6eff8c322e8";
    hash = "sha256-MUbodsjBjYNZONPSpTrveoVXSS5gCyrhQPHTBcY/4qY=";
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
