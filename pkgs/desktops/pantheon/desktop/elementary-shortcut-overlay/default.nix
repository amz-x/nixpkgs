{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  gala,
  gsettings-desktop-schemas,
  gtk4,
  glib,
  gnome-settings-daemon,
  granite9,
  libgee,
  mutter,
  pantheon-wayland,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "elementary-shortcut-overlay";
  version = "8.1.0-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "shortcut-overlay";
    rev = "679990ac50f0d095c7c821e757b7259e63272684";
    hash = "sha256-MDxBWGGmQqHFg+uHNId9n+fiPbI/Ak0vjBGKKk/HsKc=";
  };

  patches = [
    # Build with Granite 9
    # https://github.com/elementary/shortcut-overlay/pull/167
    (fetchpatch {
      name = "build-with-granite-9.patch";
      url = "https://github.com/elementary/shortcut-overlay/compare/679990ac50f0d095c7c821e757b7259e63272684...3fc75fd0813e413782f50da51e6d095d11b182f6.diff";
      hash = "sha256-jmH5Fdu5XIzULedMR26PNU8f//3tisCqjnFxcBfEQ6I=";
    })
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
    gala # org.pantheon.desktop.gala.keybindings
    gsettings-desktop-schemas # org.gnome.desktop.wm.keybindings
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.plugins.media-keys
    granite9
    gtk4
    libgee
    mutter # org.gnome.mutter.keybindings
    pantheon-wayland
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Native OS-wide shortcut overlay to be launched by Gala";
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.shortcut-overlay";
  };
}
