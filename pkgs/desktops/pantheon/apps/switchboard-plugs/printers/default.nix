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
  libgee,
  gettext,
  granite7,
  gtk4,
  cups,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "8.0.2-unstable-2026-10-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-printers";
    rev = "7c1208ba37e7c7303e62b30dfabddaac57e5084d";
    hash = "sha256-uSC6H1uEh0Y7y0vkhMyennWVtGjwjbT+vCmcbTElq5g=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/settings-printers";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };

}
