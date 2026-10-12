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
  libgtop,
  libnotify,
  libudev-zero,
  gettext,
  gnome-settings-daemon,
  granite7,
  gtk4,
  glib,
  dbus,
  polkit,
  switchboard,
  wingpanel,
  wingpanel-indicator-power,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-power";
  version = "8.1.0-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-power";
    rev = "0e19f2b738e1c709f6008ac66273423a59a0ff70";
    hash = "sha256-L+Ax4dPA1iakDBxMh1y1sy+V65SrtfgkncJgiCeGQjg=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    dbus
    gnome-settings-daemon
    glib
    granite7
    gtk4
    libadwaita
    libgee
    libgtop
    libnotify
    libudev-zero
    polkit
    switchboard
    wingpanel
    wingpanel-indicator-power # settings schema
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Power Plug";
    homepage = "https://github.com/elementary/settings-power";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
