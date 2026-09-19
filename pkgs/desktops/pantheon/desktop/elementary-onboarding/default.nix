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
  appcenter,
  elementary-settings-daemon,
  glib,
  gnome-settings-daemon,
  granite7,
  gtk4,
  libadwaita,
  libgee,
  pantheon-wayland,
}:

stdenv.mkDerivation {
  pname = "elementary-onboarding";
  version = "8.1.0-unstable-2026-09-10"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = "637dc2d4c340700bec7fc58d34885fefaee67423";
    sha256 = "sha256-Q0nfwTCwsipIhBb1Hiw9MQg9L6IwC7Pfz5XPQ7ev6lo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appcenter # settings schema
    elementary-settings-daemon # settings schema
    glib
    gnome-settings-daemon # org.gnome.settings-daemon.plugins.color
    granite7
    gtk4
    libadwaita
    libgee
    pantheon-wayland
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Onboarding app for new users designed for elementary OS";
    homepage = "https://github.com/elementary/onboarding";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.onboarding";
  };
}
