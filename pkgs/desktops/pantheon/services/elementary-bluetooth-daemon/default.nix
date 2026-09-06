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
  version = "1.1.0-unstable-2026-08-25"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "bluetooth-daemon";
    rev = "50e94329792a4be23d118d3c2289c3ffeb3ff9fa";
    hash = "sha256-rOpJYyngUJ10q91JHXxB2w+Izctufqy5041RNCE+nMA=";
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
