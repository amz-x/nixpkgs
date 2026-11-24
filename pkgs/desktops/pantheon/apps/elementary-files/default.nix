{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  libcanberra,
  gtk3,
  glib,
  libgee,
  libhandy,
  libportal-gtk3,
  granite,
  pango,
  poppler_gi,
  sqlite,
  zeitgeist,
  libcloudproviders,
  libgit2-glib,
  wrapGAppsHook3,
  systemdLibs,
}:

stdenv.mkDerivation {
  pname = "elementary-files";
  version = "7.3.3-unstable-2026-11-22";

  outputs = [
    "out"
    "dev"
  ];

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "files";
    rev = "9cec2e77e87fd3f79af2d3d67bc1f83aaa89956c";
    hash = "sha256-H0orcu3LANKXKqnuXD29rK0MZThJJsnCxODQxu9lZsE=";
  };

  postPatch = ''
    # pkexec's sanitized environment doesn't set $SHELL itself, so it
    # falls through to whatever the invoking user's login shell is
    # (fish, nu, ...) -- which the root-privileged files helper isn't
    # prepared to run commands with. Force a POSIX shell instead.
    substituteInPlace data/io.elementary.files-pkexec.in \
      --replace-fail 'pkexec "@exec_name@"' 'SHELL=/bin/sh pkexec "@exec_name@"'
  '';

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libcanberra
    libcloudproviders
    libgee
    libgit2-glib
    libhandy
    libportal-gtk3
    pango
    poppler_gi
    sqlite
    systemdLibs
    zeitgeist
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "File browser designed for elementary OS";
    homepage = "https://github.com/elementary/files";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.files";
  };
}
