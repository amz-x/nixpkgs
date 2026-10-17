{
  fetchFromGitHub,
  granite7,
  gtk4,
  lib,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
  systemd,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-bluetooth-daemon";
  version = "1.1.0-unstable-2026-10-03"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "bluetooth-daemon";
    rev = "ac17a2657c93b5236a03f4ac1a118e4dec400aa5";
    hash = "sha256-s+u123NjoVEnRXQ8FJ0MXptm+nXgDbJKHrPmqBUMH9U=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    granite7
    gtk4
    systemd
  ];

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Send and receive files via bluetooth";
    homepage = "https://github.com/elementary/bluetooth-daemon";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
    mainProgram = "io.elementary.bluetooth";
  };
})
