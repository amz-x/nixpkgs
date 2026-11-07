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
  systemdLibs,
  vala,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-bluetooth-daemon";
  version = "1.1.0-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "bluetooth-daemon";
    rev = "0b13953cf002fab4f55b0d92d7072278f0b9a7de";
    hash = "sha256-SUQIQ/8dMxEfw7+AiL45/8d2muxixUKpvRjZw8x+lo4=";
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
    systemdLibs
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
