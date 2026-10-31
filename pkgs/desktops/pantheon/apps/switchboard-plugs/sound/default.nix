{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libcanberra,
  libgee,
  glib,
  granite7,
  gtk4,
  pulseaudio,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sound";
  version = "8.0.3-unstable-2026-10-27"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sound";
    rev = "484ee80b3c79e5522bc54b13d378520243e2fbef";
    hash = "sha256-x1/D5n+BYxvZIR7Tt22jvqFT0FgO8ivPC4JyJTF+LI0=";
  };

  nativeBuildInputs = [
    glib
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libcanberra
    libgee
    pulseaudio
    switchboard
  ];

  strictDeps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Sound Plug";
    homepage = "https://github.com/elementary/settings-sound";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
