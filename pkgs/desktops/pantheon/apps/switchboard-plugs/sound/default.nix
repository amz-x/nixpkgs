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
  version = "8.0.3-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sound";
    rev = "b35275117da8daa8992d6b14915c41a3aaf29392";
    hash = "sha256-vF1riuSaIoZao4moXtb8Mfxi8GbqpFEK+3eRY3WUUNc=";
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
