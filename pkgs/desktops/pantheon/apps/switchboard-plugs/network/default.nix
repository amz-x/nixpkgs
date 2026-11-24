{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  replaceVars,
  vala,
  libadwaita,
  libgee,
  gettext,
  granite7,
  gtk4,
  networkmanager,
  networkmanagerapplet,
  libnma-gtk4,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-network";
  version = "8.2.0-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-network";
    rev = "db01b23b98ee61a34861370e6c33f79f469d0bad";
    hash = "sha256-gbDR3/hjeYmGkFYH3C58zrSwoDJxvo/AHZJKMtNY/TI=";
  };

  patches = [
    # Launch nm-connection-editor from the store for the edit connections,
    # advanced settings and VPN pages, since networkmanagerapplet isn't on
    # PATH in the session.
    (replaceVars ./fix-paths.patch {
      inherit networkmanagerapplet;
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
    libadwaita
    libgee
    networkmanager
    libnma-gtk4
    switchboard
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Networking Plug";
    homepage = "https://github.com/elementary/switchboard-plug-network";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
