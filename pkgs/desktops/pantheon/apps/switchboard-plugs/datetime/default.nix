{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  replaceVars,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  libical,
  granite7,
  gettext,
  gtk4,
  libxml2,
  switchboard,
  tzdata,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-datetime";
  version = "8.1.0-unstable-2026-11-02";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-datetime";
    rev = "5b7c4e1aa29a033d4761c029ac5861e2fd64a6e8";
    hash = "sha256-HQJTeBXAnXmhWCgT6exRBNsABPVTIHhrf6iuvfguNDE=";
  };

  patches = [
    # Read the time zone list from tzdata in the store for the time zone
    # picker, since NixOS has no /usr/share/zoneinfo.
    (replaceVars ./fix-paths.patch {
      tzdata = tzdata;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    libical
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Date & Time Plug";
    homepage = "https://github.com/elementary/switchboard-plug-datetime";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
