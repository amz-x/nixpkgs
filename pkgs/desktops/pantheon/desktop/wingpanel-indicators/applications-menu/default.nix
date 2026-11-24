{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  granite7,
  libgee,
  gettext,
  gnome-desktop,
  gtk4,
  json-glib,
  switchboard-with-plugs,
  wingpanel,
  zeitgeist,
  bc,
  libhandy,
}:

stdenv.mkDerivation {
  pname = "wingpanel-applications-menu";
  version = "8.0.4-unstable-2026-11-18";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "applications-menu";
    rev = "cd14bd318e57620972e7bede719dc926337b1019";
    hash = "sha256-Uu9HxOZ2E9RTHPnuqrUXMBqyzheU2FJQu7fRvaSPIS0=";
  };

  patches = [
    # Launch applications in separate systemd scopes
    # https://github.com/elementary/applications-menu/pull/726
    (fetchpatch {
      name = "feature-launch-apps-in-systemd-scopes.patch";
      url = "https://github.com/elementary/applications-menu/commit/77cb9c1a997f517c38ff1146e3c810a21b491079.patch";
      hash = "sha256-F5OQpRvVVR4NPDdrKcmVj3pL+XB9VJ7oa1+xZkQyT5o=";
    })
    # Run bc from the store for the search's calculator and unit converter,
    # and always enable them, since bc isn't on PATH in the session.
    (replaceVars ./fix-paths.patch {
      bc = "${bc}/bin/bc";
    })
    # A 16 bit PNG icon in the grid makes GTK's GPU renderer use high depth
    # intermediates, where SVG icons with feFlood + feBlend (e.g. Proton Mail
    # Bridge) turn into black squares. Convert such icons to 8 bit.
    ./fix-high-depth-icons.patch
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gnome-desktop
    granite7
    gtk4
    json-glib
    libgee
    libhandy
    switchboard-with-plugs
    wingpanel
    zeitgeist
  ]
  ++
    # applications-menu has a plugin to search switchboard plugins
    # see https://github.com/NixOS/nixpkgs/issues/100209
    # wingpanel's wrapper will need to pick up the fact that
    # applications-menu needs a version of switchboard with all
    # its plugins for search.
    switchboard-with-plugs.buildInputs;

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = "https://github.com/elementary/applications-menu";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
