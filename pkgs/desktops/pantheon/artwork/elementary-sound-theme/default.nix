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
  version = "1.1.0-unstable-2026-04-19"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "sound-theme";
    rev = "06e773b65939ca347bb70ad53f7d8e30e2db6c9e";
    sha256 = "sha256-KMMTVxlVQEgOt2EPKwHZRIkbBLuriC9VQLQGgPzNEq0=";
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
