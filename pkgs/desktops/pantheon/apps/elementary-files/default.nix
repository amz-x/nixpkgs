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
  version = "7.3.3-unstable-2026-10-11"; # nixpkgs-update: no auto update

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "files";
    rev = "700ae4921bf9749f62a11b81182ca5b76594c0dc";
    hash = "sha256-CH56fazfbrVNL4fR8q8WBH89DHXvZq99Bh7BN5dglsU=";
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
