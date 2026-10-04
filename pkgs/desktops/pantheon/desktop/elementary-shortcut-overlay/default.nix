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
    (fetchpatch {
      name = "Build with Granite9";
      url = "https://patch-diff.githubusercontent.com/raw/elementary/shortcut-overlay/pull/167.patch";
      hash = "sha256-v5kPo1Jg6LoBBY+BFBNjVgKId6ScY5W8NTvIZ6zhdD0=";
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
