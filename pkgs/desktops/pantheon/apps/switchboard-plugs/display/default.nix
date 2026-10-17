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
  version = "8.0.3-unstable-2026-10-07"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-display";
    rev = "931e3c0dba4efac05e9b96dee7fc20a786307421";
    hash = "sha256-w96U34IYX1ATComsGmRxHj+Xi8RVUINxb8g21bnmqmI=";
  };

  patches = [
    # Mutter offers a "variable" refresh-rate-mode variant of every mode on
    # VRR capable monitors. Add a "Variable Refresh Rate" switch per display
    # that swaps between the fixed and variable variant of the current mode,
    # only list refresh rates of the selected kind, and keep variable modes
    # out of mirroring.
    ./add-variable-refresh-rate-switch.patch
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
