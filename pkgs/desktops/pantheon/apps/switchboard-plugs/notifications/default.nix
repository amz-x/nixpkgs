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
  glib,
  granite7,
  gtk4,
  switchboard,
  elementary-notifications,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-notifications";
  version = "8.0.1-unstable-2026-09-03"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-notifications";
    rev = "46fba495be5e6138e5948e53b24d73fcec6e9591";
    hash = "sha256-/jozSkIxqqmYIxVHb8KBz63qJW6X2F99ShQVeQBWWFs=";
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
    elementary-notifications
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
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/settings-notifications";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
