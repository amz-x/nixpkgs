{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  glib,
  gtk4,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pantheon-wayland";
  version = "1.1.0-unstable-2026-04-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-wayland";
    rev = "74020b3651bd4a11b5b3d672454d6ee4064237f2";
    hash = "sha256-Ox08RjsyC0EpoWLitVGI3QNgwaot2UmKU7GCUfF3hWw=";
  };

  outputs = [
    "out"
    "dev"
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
  ];

  propagatedBuildInputs = [
    glib
    gtk4
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland integration library to the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-wayland";
    license = lib.licenses.lgpl3Plus;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
})
