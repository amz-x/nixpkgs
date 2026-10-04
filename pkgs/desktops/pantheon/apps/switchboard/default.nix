{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  sassc,
  vala,
  glib,
  gtk4,
  libadwaita,
  libgee,
  granite7,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "switchboard";
  version = "8.0.3-unstable-2026-09-26"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard";
    rev = "5641b811c33e772f4a8b24980c2ce93687c12067";
    hash = "sha256-HdUDTi0YXe8O7cU7azENHpRqncmWL1ZbGjh1ytOAf8Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  propagatedBuildInputs = [
    # Required by switchboard-3.pc.
    glib
    granite7
    gtk4
    libadwaita
    libgee
  ];

  patches = [
    ./plugs-path-env.patch
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extensible System Settings app for Pantheon";
    homepage = "https://github.com/elementary/settings";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.settings";
  };
}
