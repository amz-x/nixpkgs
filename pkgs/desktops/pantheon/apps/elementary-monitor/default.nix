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
  version = "8.0.1-unstable-2026-11-05";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "monitor";
    rev = "0fc1f37da72e0e43fd563b4a9d0c9dfc2ecb91c7";
    hash = "sha256-hXmWETQOEL2knWO4LXMgLi9OVJPqbRcZKCvSkxBU+Gw=";
  };

  patches = [
    # Load 2000 log entries at a time instead of 200
    ./feature-increase-log-chunk-size.patch

    # Journal entries without PRIORITY crashed the log view
    ./fix-log-missing-priority-crash.patch

    # Count used space of LUKS/LVM volumes on their NVMe drive
    ./fix-storage-usage.patch
  ];

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
