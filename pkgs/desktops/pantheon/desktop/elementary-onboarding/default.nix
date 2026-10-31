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
  granite9,
  gtk4,
  libadwaita,
  libgee,
  pantheon-wayland,
}:

stdenv.mkDerivation {
  pname = "elementary-onboarding";
  version = "8.1.0-unstable-2026-10-20"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "onboarding";
    rev = "70962d1850d572af4763753d0d61334f5a237e05";
    hash = "sha256-6q6s5LJk4Pgim4kNvhA5+knz2vLAC7jecBZDaBlUSsE=";
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
    granite9
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
