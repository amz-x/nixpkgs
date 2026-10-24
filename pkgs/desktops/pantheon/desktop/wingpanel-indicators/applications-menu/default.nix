{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  granite7,
  libgee,
  gettext,
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
  version = "8.0.4-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "applications-menu";
    rev = "7a0e455d57c6b285bec74e6f3f64286bcf109391";
    hash = "sha256-cJh8iuMGkpkLp6MGUCiDhlYMOcFLR/CFCrOedeHD158=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      bc = "${bc}/bin/bc";
    })
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
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
