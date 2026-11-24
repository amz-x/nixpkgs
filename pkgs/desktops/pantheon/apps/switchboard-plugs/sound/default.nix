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

stdenv.mkDerivation {
  pname = "switchboard-plug-sound";
  version = "8.0.3-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sound";
    rev = "ebdde53965188df88952c58ca3fc4d04baa4b7bb";
    hash = "sha256-EaTeiKNyfJnJ+2e+tN4r8jRJpZe1YXVQAA+Vapc0r3g=";
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
