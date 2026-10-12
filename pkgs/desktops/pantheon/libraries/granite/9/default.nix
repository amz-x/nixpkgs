{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  sassc,
  vala,
  pkg-config,
  libgee,
  libshumate,
  gtk4,
  glib,
  gettext,
  gsettings-desktop-schemas,
  gobject-introspection,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "granite";
  version = "7.8.1-unstable-2026-10-09"; # nixpkgs-update: no auto update

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    rev = "28c71ff7185f8e414d698d3ccbce2ca2bc59b316";
    hash = "sha256-IUCjOW/r1pQ85ILFR3zkzy1mAS4j45/TyzpZgAd/42M=";
  };

  nativeBuildInputs = [
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
    libshumate # demo
  ];

  propagatedBuildInputs = [
    glib
    gsettings-desktop-schemas # is_clock_format_12h uses "org.gnome.desktop.interface clock-format"
    gtk4
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extension to GTK used by elementary OS";
    longDescription = ''
      Granite is a companion library for GTK and GLib. Among other things, it provides complex widgets and convenience functions
      designed for use in apps built for elementary OS.
    '';
    homepage = "https://github.com/elementary/granite";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "granite-9-demo";
  };
}
