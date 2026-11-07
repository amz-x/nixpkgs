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
  version = "8.1.0-unstable-2026-11-05";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "shortcut-overlay";
    rev = "011ad8858b66501be292e4df60faefcf6957be5a";
    hash = "sha256-kXBE8dshVZe1MoW9eMUwduZVeo9K0+oBx2a+ltBt1m4=";
  };

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
