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
  version = "8.1.1-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "feedback";
    rev = "57ff400e9f01d3ce2b69b01625328a4e9fff6889";
    hash = "sha256-ee0+pNueGQGAOnOU0bBOR41Xcd3gcBnEgOS5ARgVpj8=";
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
