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
  version = "8.1.1-unstable-2026-11-10";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = "a3e6fe313d1761b0c25e1bea362a28104f02b39f";
    hash = "sha256-bH1/UVxioBuDZfZ5hQXxCf8Zzg1fNtbgJzNNurfM30k=";
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
