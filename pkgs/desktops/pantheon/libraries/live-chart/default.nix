{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  xvfb-run,
  gtk4,
  libgee,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "live-chart";
  version = "2.0.0-unstable-2026-09-23"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "live-chart";
    rev = "7fd3950fbffa7ea575744dc955aeac1e915fa229";
    hash = "sha256-WaHT6T68pfPylfjNc8RPRgFJHfv2nhe1g6Vv++2L5ec=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    xvfb-run
  ];

  buildInputs = [
    gtk4
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Real-time charting library for Vala and GTK4 based on Cairo";
    homepage = "https://github.com/elementary/live-chart";
    license = lib.licenses.mit;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
})
