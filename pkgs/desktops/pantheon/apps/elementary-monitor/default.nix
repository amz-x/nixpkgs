{
  stdenv,
  lib,
  fetchFromGitHub,
  desktop-file-utils,
  gettext,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  wrapGAppsHook4,
  flatpak,
  glib,
  granite7,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libgtop,
  libx11,
  linuxPackages,
  live-chart,
  pciutils,
  systemd,
  udisks,
  wingpanel,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-monitor";
  version = "8.0.1-unstable-2026-09-25"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "monitor";
    rev = "789e453719e4e7e43297887394c2808a661a4c6a";
    hash = "sha256-Nz12wbRa9b4DoGkVpMqp6Zy04kAKD1AMU8kz0uQfITI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    granite7
    gtk4
    json-glib
    libadwaita
    libgee
    libgtop
    libx11
    linuxPackages.nvidia_x11.settings.libXNVCtrl
    live-chart
    pciutils
    systemd
    udisks
    wingpanel
  ];

  mesonFlags = [ "-Dindicator-wingpanel=enabled" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage processes and monitor system resources";
    homepage = "https://github.com/elementary/monitor";
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    mainProgram = "io.elementary.monitor";
  };
})
