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
  version = "8.1.0-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-power";
    rev = "38064f1a0827c5df746c0e38c0734cb021428eb9";
    hash = "sha256-4c20w1JrmHL8BInm+x4WOuNEzHCbX+O5+KLdqsLn3NM=";
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
