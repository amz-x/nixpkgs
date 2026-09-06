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
  systemd,
  libadwaita,
  libx11,
}:

stdenv.mkDerivation {
  pname = "xdg-desktop-portal-pantheon";
  version = "8.2.0-unstable-2026-08-14"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "portals";
    rev = "304b75263b32ffa3d608f15c80cc505e97f27aec";
    hash = "sha256-VWBMuZiJ+XgibvJfOJd2kCJIFI7QTDW+AM9yMm/ZlVQ=";
  };

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
    systemd
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
