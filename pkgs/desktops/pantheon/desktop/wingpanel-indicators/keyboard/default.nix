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
  version = "2.4.2-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-keyboard";
    rev = "10dd7c4f1b3b1439bf7c6bdbacb29533943ccdf6";
    sha256 = "sha256-WJpJEid0JcDKLebMZwBXE23ZlFsf4hPMA3YCEgiT7gQ=";
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
