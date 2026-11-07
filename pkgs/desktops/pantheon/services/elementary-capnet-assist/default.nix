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
  version = "9.0.0-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "capnet-assist";
    rev = "01ebca935c99f00d72650d72106ae31379b9a4bc";
    hash = "sha256-HYOWy2xkYMH0cJKdQFN3NoYR1LC7ml4Ft+QZEayPFOk=";
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
