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
  version = "8.0.2-unstable-2026-10-19";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-power";
    rev = "8a11cb2fe8f0848d05c60528c85273da4a014d0e";
    sha256 = "sha256-0nB4I3WK5Oct8ulRvJtlppbDNF96gfntD9I8KW+ZDU8=";
  };

  patches = [
    # Control brightness through gala's BrightnessManager, since mutter 49+
    # removed the gnome-settings-daemon backlight interface it used
    # https://github.com/elementary/panel-power/pull/301
    ./feature-gala-brightness-manager.patch

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
