{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  accountsservice,
  dbus,
  desktop-file-utils,
  fwupd,
  gdk-pixbuf,
  geoclue2,
  gexiv2_0_10,
  glib,
  gnome-settings-daemon,
  gobject-introspection,
  gtk4,
  granite7,
  libgee,
  packagekit,
  systemdLibs,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "elementary-settings-daemon";
  version = "8.5.0-unstable-2026-10-11"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = "a9c852f6468fdd7070e4f0a4e5ca6702239a1264";
    hash = "sha256-jE5aYojIDflXMmCzQErbvBmT8/L2CvodRL6xYtUXWfQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    dbus
    fwupd
    gdk-pixbuf
    geoclue2
    gexiv2_0_10
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.* gschema
    gtk4
    granite7
    libgee
    packagekit
    systemdLibs
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Settings daemon for Pantheon";
    homepage = "https://github.com/elementary/settings-daemon";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "io.elementary.settings-daemon";
  };
}
