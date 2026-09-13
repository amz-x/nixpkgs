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
  version = "1.1.0-unstable-2026-09-07"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "bluetooth-daemon";
    rev = "23f64077797a81050e2fe96f3e831ae8db194fe0";
    hash = "sha256-UKua7aSY+8cuzh9UsCBG5NqexaLeCWonB6A8BlVqQ3g=";
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
