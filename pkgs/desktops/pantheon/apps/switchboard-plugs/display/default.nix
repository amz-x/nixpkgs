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
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-display";
  version = "8.0.3-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-display";
    rev = "fb29a0610458ddf431c033fb06fee7d2ce695e05";
    hash = "sha256-Cw0+10dLoyaD2fL0vV0VVtD1JH/IxXdoG+1ASkL4yAI=";
  };

  patches = [
    # Mutter offers a "variable" refresh-rate-mode variant of every mode on
    # VRR capable monitors. Add a "Variable Refresh Rate" switch per display
    # that swaps between the fixed and variable variant of the current mode,
    # only list refresh rates of the selected kind, and keep variable modes
    # out of mirroring.
    ./feature-add-variable-refresh-rate-switch.patch

    # Follow gala's D-Bus rename to io.elementary.gala
    # https://github.com/elementary/gala/pull/2046
    ./feature-gala-rdnn-dbus.patch
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
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
    description = "Switchboard Displays Plug";
    homepage = "https://github.com/elementary/settings-display";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
