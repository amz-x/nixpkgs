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
  version = "2.4.2-unstable-2026-09-15"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-keyboard";
    rev = "2d086e0177d7aa9a9e6aa4eb11fa7fb77c628c76";
    sha256 = "sha256-LJYrROifehdjqMwmjAgTDqvQe/RGD+S+tPMMCd79JR4=";
  };

  patches = [
     # Launch gkbd-keyboard-display from the store for "Show Keyboard Layout",
    # since libgnomekbd isn't on PATH in the panel session.
    (replaceVars ./fix-paths.patch {
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })

    # Caps/Num Lock indicators only update once the panel is interacted with on
    # Wayland, since the panel never holds keyboard focus. Get the lock state
    # from the compositor through wingpanel-interface instead.
    # https://github.com/elementary/panel-keyboard/issues/130
    ./fix-wayland-lock-state.patch
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
