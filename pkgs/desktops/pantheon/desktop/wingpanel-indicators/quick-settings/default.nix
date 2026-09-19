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
  version = "1.4.0-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = "425729a4fdc5ec80b355e14c1095a5a004240180";
    hash = "sha256-YruxmKxhOFU/OKyZ8OF1FVzVZnzxhxWkbyigzZQHl8Y=";
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
