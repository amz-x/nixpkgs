{
  lib,
  stdenv,
  desktop-file-utils,
  nix-update-script,
  fetchFromGitHub,
  flatpak,
  gettext,
  glib,
  granite7,
  gtk4,
  meson,
  ninja,
  pkg-config,
  vala,
  libxml2,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "sideload";
  version = "6.3.1-unstable-2026-09-23"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sideload";
    rev = "827fcd974d5e25f9f4ac7a7a96ccddad2234c0a4";
    hash = "sha256-eyg8/AzRo7f/ENYtcID4BfLkch3PcRx18uGcDKC5YBQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    granite7
    gtk4
    libxml2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/sideload";
    description = "Flatpak installer, designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.sideload";
  };
}
