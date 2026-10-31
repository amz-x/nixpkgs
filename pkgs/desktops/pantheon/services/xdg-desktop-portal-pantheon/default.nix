{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  accountsservice,
  glib,
  granite7,
  gsettings-desktop-schemas,
  gtk4,
  pantheon-wayland,
  systemdLibs,
  libadwaita,
  libx11,
}:

stdenv.mkDerivation {
  pname = "xdg-desktop-portal-pantheon";
  version = "8.2.0-unstable-2026-10-28"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "portals";
    rev = "707e7316a9b9aae982212bdac20c1780a5af7e8f";
    hash = "sha256-mIYLRU2D6T6KjxjTEPr0qKxnkVviA0XbAQaUwwYvz0k=";
  };

  patches = [
    # Follow gala's D-Bus rename to io.elementary.gala
    # https://github.com/elementary/gala/pull/2046
    ./feature-rdnn-dbus.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    glib
    granite7
    gsettings-desktop-schemas
    gtk4
    pantheon-wayland
    systemdLibs
    libadwaita
    libx11
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Backend implementation for xdg-desktop-portal for the Pantheon desktop environment";
    homepage = "https://github.com/elementary/portals";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
