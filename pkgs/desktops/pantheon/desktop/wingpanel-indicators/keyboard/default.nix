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
  version = "2.4.2-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-keyboard";
    rev = "2ce43001c01f9704f75f0d84caf89e4bb4d6a192";
    hash = "sha256-13DP8bvollwSHEW/Om1zePg1PmGNfr7HaTBMu0VH790=";
  };

  patches = [
    # Launch gkbd-keyboard-display from the store for "Show Keyboard Layout",
    # since libgnomekbd isn't on PATH in the panel session.
    (replaceVars ./fix-paths.patch {
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })

    # Follow gala's D-Bus rename to io.elementary.gala
    # https://github.com/elementary/gala/pull/2046
    ./feature-gala-rdnn-dbus.patch
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
