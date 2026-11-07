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
  version = "7.8.1-unstable-2026-11-05";

  outputs = [
    "out"
    "dev"
  ];

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    rev = "7d532fa215654bbf427795fc6fa6272d284051e3";
    hash = "sha256-7HsYY1w2kmKd0UZIoXrbblKcGrL54+A5XwU6IXF2edA=";
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
