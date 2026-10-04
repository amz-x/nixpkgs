{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  meson,
  ninja,
  sassc,
  vala,
  pkg-config,
  libgee,
  libgtop,
  gtk4,
  glib,
  pantheon,
  gettext,
  gobject-introspection,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "optimizer";
  version = "1.2.1-unstable-2026-10-02"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "amz-x";
    repo = "optimizer";
    rev = "ad9044eab29d12423d3f62577366158db1c925f5";
    hash = "sha256-CL0MhFheHbF+9XKobwMWPQxowcJodA9GVu50M9+SVys=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libgee
    libgtop
    pantheon.granite9
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Clean up your system";
    longDescription = ''
      Find out what's eating up your system resources and delete unnecessary files from your disk.
    '';
    homepage = "https://github.com/amz-x/optimizer";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "com.github.hannesschulze.optimizer";
  };
}
