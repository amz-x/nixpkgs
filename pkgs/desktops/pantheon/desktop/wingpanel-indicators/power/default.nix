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
  libnotify,
  udev,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-power";
  version = "8.0.2-unstable-2026-11-19";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-power";
    rev = "afee7a10733f69c4df9ea5febd8975890c44d7bb";
    hash = "sha256-0nxflB7W2dSK/1rEZ76qV9UEjI4yxGWvMMej/O7obWA=";
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
    libnotify
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
