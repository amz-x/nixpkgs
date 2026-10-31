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
  version = "8.2.0-unstable-2026-10-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-network";
    rev = "737467fb79849b617859784bd85157894787a459";
    hash = "sha256-62si7PkmBrWYIsKsUaHbU/ANfIbRav5ltF9emLYCVNc=";
  };

  patches = [
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
