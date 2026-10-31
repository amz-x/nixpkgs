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
  version = "8.0.3-unstable-2026-10-29"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard";
    rev = "27e7582459fa7b6c06db7106dec0d13dd695f3f6";
    hash = "sha256-Rs1X+NrK+0Kf5dpzh2xvmEt+4tpL4azSeyxiL3p9W0I=";
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
    ./fix-plugs-path-env.patch
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
