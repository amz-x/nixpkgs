{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,
  gnome-power-manager,
  pkg-config,
  meson,
  ninja,
  vala,
  elementary-settings-daemon,
  gettext,
  gtk4,
  granite7,
  libgtop,
  udev,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-power";
  version = "8.0.2-unstable-2026-11-23";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-power";
    rev = "211a9b3186d2d37a21102493179c65de2d0005a8";
    hash = "sha256-zez3468zt57e9hHeuMZtobK2nwaoKZ74qV4PzTq0ibk=";
  };

  patches = [
    # Always show the indicator, even without battery or backlight,
    # so that power profiles can be toggled on desktops. In that case the
    # popover only has the power modes, so label them with a header.
    ./feature-always-show-indicator.patch

    # DeviceList removed rows with Widget.destroy (), which in GTK4 only emits
    # a signal, so every Bluetooth reconnect of a battery-reporting device
    # (headset, mouse) added another row for the same device.
    ./fix-duplicate-device-rows.patch

    # Startup enumeration skipped devices with unknown technology and state,
    # which is how BlueZ reports headsets and mice, so they only showed up
    # after a reconnect.
    ./fix-bluetooth-devices-at-startup.patch

    # Launch gnome-power-statistics from the store when a device is clicked.
    (replaceVars ./fix-paths.patch {
      gnome_power_manager = gnome-power-manager;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    granite7
    gtk4
    libgee
    libgtop
    udev
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Power Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-power";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
