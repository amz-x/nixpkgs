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
  version = "8.0.2-unstable-2026-11-20";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-security-privacy";
    rev = "faf8b5e5751d04fbf98ac296e11a6a8a2a4ae001";
    hash = "sha256-54ZZkhWL5GWK9QDoiRVnHvOE6BXF/23ZFI8QU0PYK7Q=";
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
