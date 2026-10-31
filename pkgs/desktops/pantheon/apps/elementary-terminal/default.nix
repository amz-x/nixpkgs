{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  gtk4,
  granite7,
  libadwaita,
  vte-gtk4,
  libgee,
  pcre2,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "elementary-terminal";
  version = "8.1.0-unstable-2026-10-19"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "terminal";
    rev = "a119bb253910b8451fd3b079629b323dc1af3687";
    hash = "sha256-JmAyommG089S8p051Fgl+pXwxXF6jQkYVQ/PXBQZSms=";
  };

  patches = [
    # Regression from elementary/terminal#1019: `-w`/`-t` stopped adding a
    # tab once a window is open, so Files' "Open in > Terminal" did nothing.
    ./fix-new-tab-existing-window.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    pcre2
    vte-gtk4
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Terminal emulator designed for elementary OS";
    longDescription = ''
      A super lightweight, beautiful, and simple terminal. Comes with sane defaults, browser-class tabs, sudo paste protection,
      smart copy/paste, and little to no configuration.
    '';
    homepage = "https://github.com/elementary/terminal";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.terminal";
  };
}
