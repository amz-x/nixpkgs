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
  pantheon-wayland,
  glib,
  granite7,
  gtk4,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-display";
  version = "8.0.3-unstable-2026-11-20";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-display";
    rev = "5512d54f942e25323f5f7c3f28ce171e952487ae";
    hash = "sha256-jdY3lfdi3ihXUs4pPkXJ73uZ/fBL1usKp1GoD/c2pvg=";
  };

  patches = [
    # Mutter offers a "variable" refresh-rate-mode variant of every mode on
    # VRR capable monitors. Add a "Variable Refresh Rate" switch per display
    # that swaps between the fixed and variable variant of the current mode,
    # only list refresh rates of the selected kind, and keep variable modes
    # out of mirroring.
    ./feature-add-variable-refresh-rate-switch.patch
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
    pantheon-wayland
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
