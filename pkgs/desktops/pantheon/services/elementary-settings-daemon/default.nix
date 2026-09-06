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
  gexiv2,
  glib,
  gnome-settings-daemon,
  gobject-introspection,
  gtk3,
  granite7,
  libgee,
  packagekit,
  systemd,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "elementary-settings-daemon";
  version = "8.5.0-unstable-2026-08-30"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = "ccb3ec6e978985a945aa8a255809a7735e0e59fe";
    hash = "sha256-DFPpLcAjiHhC/J6jJ/5PvrFtCCylZdIXZSMxejcBrWg=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    dbus
    fwupd
    gdk-pixbuf
    geoclue2
    gexiv2
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.* gschema
    gtk3
    granite7
    libgee
    packagekit
    systemd
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
