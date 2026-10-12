{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  python3,
  ninja,
  pkg-config,
  vala,
  glib,
  libgee,
  dbus,
  glib-networking,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "contractor";
  version = "0.3.5-unstable-2026-08-25"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "contractor";
    rev = "78d82ee992fc6a618fbdbad3080369e8e0c68d79";
    sha256 = "sha256-7za0rWLAuWvf2//MoYOOQAaJETBI1cLpZ4tWAvEsiwg=";
  };

  nativeBuildInputs = [
    dbus
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    glib-networking
    libgee
  ];

  env.PKG_CONFIG_DBUS_1_SESSION_BUS_SERVICES_DIR = "${placeholder "out"}/share/dbus-1/services";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Desktop-wide extension service used by elementary OS";
    homepage = "https://github.com/elementary/contractor";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "contractor";
  };
}
