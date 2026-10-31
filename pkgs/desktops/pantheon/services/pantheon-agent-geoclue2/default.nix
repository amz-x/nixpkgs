{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  gtk3,
  libgee,
  desktop-file-utils,
  geoclue2,
  granite,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-geoclue2";
  version = "1.0.6-unstable-2023-04-11"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "pantheon-agent-geoclue2";
    rev = "aab98c3f44dc912815755d249bd341a822426c73";
    hash = "sha256-Gm4T1fMii7d6wUN1rs3SoMtiwHbc8EuzmhP4LNU4nNc=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    geoclue2
    granite
    gtk3
    libgee
  ];

  # This should be provided by a post_install.py script - See -> https://github.com/elementary/pantheon-agent-geoclue2/pull/21
  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Pantheon Geoclue2 Agent";
    homepage = "https://github.com/elementary/pantheon-agent-geoclue2";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
