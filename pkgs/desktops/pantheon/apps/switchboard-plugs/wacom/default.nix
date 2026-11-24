{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  glib,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  libgudev,
  libwacom,
  switchboard,
  libxi,
  libx11,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-wacom";
  version = "8.0.2-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-wacom";
    rev = "011f69b33aa57c2344af915e16bff5d8317c9689";
    hash = "sha256-RElDTnW3FKCN1TDHdtysVImuGV8vvesCrirO+WvvIZk=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    libgee
    libgudev
    libwacom
    switchboard
    libx11
    libxi
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Wacom Plug";
    homepage = "https://github.com/elementary/settings-wacom";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
