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

stdenv.mkDerivation rec {
  pname = "elementary-capnet-assist";
  version = "9.0.0-unstable-2026-10-14"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "capnet-assist";
    rev = "75117f3a6ba52a137e42e137a45038885ee11151";
    hash = "sha256-IEitFJnQECEkT8eafPZ+9hPQuWoTbqfsoUh1zUfOHYM=";
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
