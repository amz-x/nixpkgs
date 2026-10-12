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
  granite7,
  libadwaita,
  libgee,
  gcr_4,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "elementary-capnet-assist";
  version = "8.0.2-unstable-2026-10-03";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "capnet-assist";
    rev = "7442c62e5ae410e32be4146a50cbf39389533245";
    hash = "sha256-RgPVdO2SIzJtPxt6mnfzbZRBoKpdq3ukbdlolcIXPN0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gcr_4
    granite7
    gtk4
    libadwaita
    libgee
    webkitgtk_6_0
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Small WebKit app that assists a user with login when a captive portal is detected";
    homepage = "https://github.com/elementary/capnet-assist";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.capnet-assist";
  };
}
