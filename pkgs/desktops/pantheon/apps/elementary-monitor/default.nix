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
  udisks,
  wingpanel,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-monitor";
  version = "8.0.1-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "monitor";
    rev = "e93d5f87f55bd89c361e7841f7b7e55c831407be";
    hash = "sha256-kqLxE568yUT2nT/Eoo2l3Cw1hgwiKs2QaHnClylZzvw=";
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
