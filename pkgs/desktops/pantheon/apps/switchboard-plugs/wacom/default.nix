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
  version = "8.0.2-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-wacom";
    rev = "eaf9db7361c87653011e21fd426f6a657759a3de";
    hash = "sha256-jHgr6gOI+7hzfj3iV1v8N8fYMr3sl8EiA2LrvXAi3Dw=";
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
