{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gcr_4,
  gtk4,
  libadwaita,
  libgee,
  granite7,
  pantheon-wayland,
  polkit,
  systemdLibs,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "pantheon-agent-polkit";
  version = "8.1.0-unstable-2026-10-05"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-agent-polkit";
    rev = "0417c127ab98a0ae4a12e0b9dd7649edecc14da7";
    hash = "sha256-hkip+SAG3cU+WF4MiKu/Im77d1fVDlRkH2InssxDhmc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gcr_4
    granite7
    gtk4
    libadwaita
    libgee
    pantheon-wayland
    polkit
    systemdLibs
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = "https://github.com/elementary/pantheon-agent-polkit";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
