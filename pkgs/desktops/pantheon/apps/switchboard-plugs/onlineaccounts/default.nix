{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  evolution-data-server-gtk4,
  glib,
  granite7,
  gtk4,
  libadwaita,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-onlineaccounts";
  version = "8.0.2-unstable-2026-10-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-onlineaccounts";
    rev = "87c36d853edd57aa76e050437532fa686debbc31";
    hash = "sha256-7ewN86xZ4XmYFB6xVpxWzsWof/SCZUuhlAnHApFXVlU=";
  };

  nativeBuildInputs = [
    glib # glib-compile-resources
    gtk4 # gtk-update-icon-cache
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    evolution-data-server-gtk4
    glib
    granite7
    gtk4
    libadwaita
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Online Accounts Plug";
    homepage = "https://github.com/elementary/settings-onlineaccounts";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
