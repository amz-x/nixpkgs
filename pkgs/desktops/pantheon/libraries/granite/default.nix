{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  meson,
  ninja,
  vala,
  pkg-config,
  libgee,
  gtk3,
  glib,
  gettext,
  gsettings-desktop-schemas,
  gobject-introspection,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "granite";
  version = "6.2.0"; # nixpkgs-update: no auto update

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "granite";
    rev = version;
    sha256 = "sha256-WM0Wo9giVP5pkMFaPCHsMfnAP6xD71zg6QLCYV6lmkY=";
  };

  patches = [
    # contractor renamed its D-Bus name from org.elementary.Contractor to
    # io.elementary.Contractor (elementary/contractor#41), so without this
    # ContractorProxy finds no service and apps get no contracts, e.g. no
    # "Compress"/"Extract Here" in Files' context menu.
    # https://github.com/elementary/granite/pull/1051
    (fetchpatch {
      name = "rename-contractor-rdnn.patch";
      url = "https://github.com/elementary/granite/commit/578369486e204065a714b92fd0c09892223cf2f8.patch";
      hash = "sha256-W+Px6TnOQUReTnD5If2v/KbJMKXD3HnOvXJbKOuHTiw=";
    })
  ];

  nativeBuildInputs = [
    gettext
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    glib
    gsettings-desktop-schemas # is_clock_format_12h uses "org.gnome.desktop.interface clock-format"
    gtk3
    libgee
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

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
    mainProgram = "granite-demo";
  };
}
