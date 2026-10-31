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
  version = "8.0.2-unstable-2026-09-03"; # nixpkgs-update: no auto update

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-security-privacy";
    rev = "117468c632315b190a96d07e18a161090a8c6f85";
    hash = "sha256-jyif8drcvR52MEbhTGcKBm3ftzOExcTrTrbO2ZVIANg=";
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
