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

stdenv.mkDerivation rec {
  pname = "switchboard-plug-wacom";
  version = "8.0.2-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-wacom";
    rev = "e95f2310c70dd2eea1eeab45be1874c1c45b11e7";
    hash = "sha256-UpEmpEe5AxGYA8tJrT7JfOlQ3NYlOOOjD72yBIbdobI=";
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
