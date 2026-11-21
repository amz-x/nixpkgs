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

stdenv.mkDerivation {
  pname = "switchboard-plug-onlineaccounts";
  version = "8.0.2-unstable-2026-11-20";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-onlineaccounts";
    rev = "d7da7703f641fba278a23259c0f03bfa073b3a0d";
    hash = "sha256-FWNRQw7mFFmME4M3W0uSblfiK6uMWHxdpXoDjdPy7CE=";
  };

  patches = [
    # Camel rejected mail servers with untrusted certificates (self-signed,
    # unknown CA) with "Unacceptable TLS certificate", since the session never
    # asked; show Evolution Data Server's trust prompt like Evolution does.
    ./feature-trust-prompt-for-mail-certificates.patch
  ];

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
