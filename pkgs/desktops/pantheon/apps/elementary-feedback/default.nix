{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  glib,
  granite9,
  libadwaita,
  libgee,
  wrapGAppsHook4,
  appstream,
}:

stdenv.mkDerivation {
  pname = "elementary-feedback";
  version = "8.1.1-unstable-2026-11-17";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = "397d6327a56df362ca9ee2049bc2ec4ac2bd2958";
    hash = "sha256-AUMgKeeAVY+vWpMNcvs8QzC5hiVtSyxmp86h5uT6GNk=";
  };

  patches = [
    # The standard location to the metadata pool where metadata
    # will be read from is likely hardcoded as /usr/share/metainfo
    # https://github.com/ximion/appstream/blob/v0.15.2/src/as-pool.c#L117
    # https://www.freedesktop.org/software/appstream/docs/chap-Metadata.html#spec-component-location
    ./fix-metadata-path.patch
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    granite9
    gtk4
    libadwaita
    libgee
    glib
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GitHub Issue Reporter designed for elementary OS";
    homepage = "https://github.com/elementary/feedback";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.feedback";
  };
}
