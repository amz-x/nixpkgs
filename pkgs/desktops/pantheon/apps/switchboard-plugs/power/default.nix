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
  version = "8.1.0-unstable-2026-11-20";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-power";
    rev = "a346c20084096e64a844eab459701bfccdfce4ba";
    hash = "sha256-Q7C+hsZWt5oTBiZi/+WPDi2yer/3+3YWjdHOSI/YGc0=";
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
