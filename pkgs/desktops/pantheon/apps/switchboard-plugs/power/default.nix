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
  version = "8.1.0-unstable-2026-10-27"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-power";
    rev = "0eb59d3af2e48a24b3ecf436943eddd585187268";
    hash = "sha256-rJhm/0t6WyDJ2Zznae6nlwhXVVwtLK7p3kcsEaJmKZU=";
  };

  patches = [
    # Control brightness through gala's BrightnessManager, since mutter 49+
    # removed the gnome-settings-daemon backlight interface it used
    # https://github.com/elementary/settings-power/pull/301
    ./feature-gala-brightness-manager.patch
  ];

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
