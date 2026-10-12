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
  version = "8.2.0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-network";
    rev = "9bc171b06a17d5af83e6339b2a79a2ad42485d3a";
    hash = "sha256-unGQ6HGTCz/dxc6ygRe2+9Vy+R2tIFnnJz++x0AwVGE=";
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
