{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  glib,
  granite7,
  gtk4,
  libadwaita,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-dock";
  version = "8.3.3-unstable-2026-08-27"; # nixpkgs-update: no auto update

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "16940666b5d89bc39f718f8eb6ffc44f4772aea2";
    hash = "sha256-bRLxuKEJhXG2ZOhi1RJMAKg7VLhoBDCcVfeuSTBX1hw=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    wayland
  ];

  # Fix building with GCC 14
  # https://github.com/elementary/dock/issues/418
  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.dock";
  };
})
