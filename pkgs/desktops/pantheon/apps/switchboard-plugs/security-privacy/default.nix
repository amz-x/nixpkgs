{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  elementary-settings-daemon,
  libgee,
  gettext,
  granite7,
  gsettings-desktop-schemas,
  gala,
  gtk4,
  glib,
  polkit,
  zeitgeist,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-security-privacy";
  version = "8.0.2-unstable-2026-07-25";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-security-privacy";
    rev = "c372cdc5c904e4fd5536b2740ac6105a1f008cb8";
    hash = "sha256-SNKt+vW1PwauLIYlGY3dlMkI1XfvjLTFkw2tCNWqjbE=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon # settings schema
    gala
    glib
    granite7
    gsettings-desktop-schemas
    gtk4
    libgee
    polkit
    switchboard
    zeitgeist
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Security & Privacy Plug";
    homepage = "https://github.com/elementary/settings-security-privacy";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };

}
