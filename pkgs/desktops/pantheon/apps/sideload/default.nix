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
  version = "6.3.1-unstable-2026-07-25";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sideload";
    rev = "aa4ede08d3c2893cc85006d92ef311af7cfe0ab3";
    hash = "sha256-SstAqmuCBa05UHRAKGhmO9sd71176VK8a951gO+nG14=";
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
