{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  json-glib,
  libadwaita,
  libgee,
  libgtop,
  libgudev,
  libsoup_3,
  gettext,
  glib,
  granite7,
  gtk4,
  packagekit,
  polkit,
  switchboard,
  udisks,
  fwupd,
  appstream,
  elementary-settings-daemon,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-about";
  version = "8.2.3-unstable-2026-10-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-system";
    rev = "f0766b77f0aeb482176d6e609365187a3e5203a4";
    hash = "sha256-UvY6KWFBYfy4Y/7ZqosJ5tK2kKNa3Xkd+VmgIu+VEQ4=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    appstream
    elementary-settings-daemon # for gsettings schemas
    fwupd
    granite7
    gtk4
    json-glib
    libadwaita
    libgee
    libgtop
    libgudev
    libsoup_3
    packagekit
    polkit
    switchboard
    udisks
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard About Plug";
    homepage = "https://github.com/elementary/settings-system";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };

}
