{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "elementary-sound-theme";
  version = "1.1.0-unstable-2026-10-03"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sound-theme";
    rev = "8515a06180a3a58101eb96bbfe067789843a72b4";
    sha256 = "sha256-6aquTm5bwypOB2QOrO9M9jKIKEu3XCWqDE1gwpdb+8k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Set of system sounds for elementary";
    homepage = "https://github.com/elementary/sound-theme";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
