{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  glib,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  accountsservice,
  elementary-settings-daemon,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  libhandy,
  libportal,
  packagekit,
  wayland,
  wingpanel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wingpanel-quick-settings";
  version = "1.4.0-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = "fb721d4b5640a2a25ae011370c8fe8aaff8d93f4";
    hash = "sha256-00YuBeHub49fe9F3ZP92ZukeE4TQ2mGkGfSNh1CgH3E=";
  };

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
  ];

  buildInputs = [
    accountsservice
    elementary-settings-daemon # for prefers-color-scheme
    glib
    granite7
    gtk4
    libadwaita
    libgee
    libhandy
    libportal
    packagekit
    wayland
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Quick settings menu for Wingpanel";
    homepage = "https://github.com/elementary/quick-settings";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
})
