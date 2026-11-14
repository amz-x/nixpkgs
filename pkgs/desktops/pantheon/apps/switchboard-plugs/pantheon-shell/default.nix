{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  libadwaita,
  libgee,
  granite7,
  gexiv2_0_10,
  gnome-settings-daemon,
  elementary-settings-daemon,
  gtk4,
  gala,
  wingpanel,
  wingpanel-indicator-keyboard,
  wingpanel-quick-settings,
  switchboard,
  gettext,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-pantheon-shell";
  version = "8.3.0-unstable-2026-11-09";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-desktop";
    rev = "4ae2976173e22ff0b66b22b9a4e80477159176d0";
    hash = "sha256-j0j6GtSp3617WSn4xVhkXwMpL4DNEdAtesHzQ7MCQMM=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    gala
    gexiv2_0_10
    glib
    gnome-settings-daemon
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel
    wingpanel-indicator-keyboard # gsettings schemas
    wingpanel-quick-settings # gsettings schemas
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Desktop Plug";
    homepage = "https://github.com/elementary/settings-desktop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
