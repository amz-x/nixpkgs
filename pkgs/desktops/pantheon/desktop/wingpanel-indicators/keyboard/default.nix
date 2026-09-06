{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  replaceVars,
  vala,
  gtk4,
  granite7,
  libxml2,
  wingpanel,
  libgee,
  xkeyboard-config,
  libgnomekbd,
  ibus,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-keyboard";
  version = "2.4.2-unstable-2026-06-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-keyboard";
    rev = "31b6972293f442b52f137efb920e2f98e9d94e56";
    sha256 = "sha256-TGOVZvM/P6qH/mAhPdHONz2jyv12XK1Gaoh0u2G4elU=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    libxml2
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    ibus
    libgee
    wingpanel
    xkeyboard-config
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Keyboard Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-keyboard";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
