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
  version = "8.0.2-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-onlineaccounts";
    rev = "1a0e423c2290fcf749829364088d5f0f6b8a4035";
    hash = "sha256-EbWKKNuXG2bpFveXabXv4aKCL3JW4+OiTFADGxWcTfI=";
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
