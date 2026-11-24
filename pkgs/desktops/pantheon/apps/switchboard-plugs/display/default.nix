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
  version = "8.0.3-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-display";
    rev = "6c1af54ff9c986077a6f3b944ea9e980f1361fc6";
    hash = "sha256-9kXFauV2iEY3yRQV9N97RNYpK90KHtjzPeERa85zoqQ=";
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
