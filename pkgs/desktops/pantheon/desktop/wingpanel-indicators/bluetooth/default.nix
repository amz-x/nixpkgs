{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  glib,
  granite7,
  libnotify,
  wingpanel,
  libgee,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-bluetooth";
  version = "8.0.0-unstable-2026-10-19"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-bluetooth";
    rev = "6c7858a340a568f3702f96e861e0667bd32cdc48";
    hash = "sha256-i9a0dZkRsFAElBuRQ6i+7GCp8VT6pZdNk7HvA2A9Vf4=";
  };

  nativeBuildInputs = [
    glib # for glib-compile-schemas
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libgee
    libnotify
    wingpanel
  ];

  # Upstream calls gnome.post_install(glib_compile_schemas: true) even though
  # this package doesn't ship any schemas, so the target directory needs to
  # exist before ninja install runs the post-install script
  preInstall = ''
    mkdir -p "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bluetooth Indicator for Wingpanel";
    mainProgram = "io.elementary.bluetooth";
    homepage = "https://github.com/elementary/panel-bluetooth";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
