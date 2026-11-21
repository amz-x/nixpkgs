{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  libgee,
  libxml2,
  granite7,
  gtk4,
  switchboard,
  gettext,
  gnome-settings-daemon,
  glib,
  gala, # needed for gestures support
  touchegg,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-mouse-touchpad";
  version = "8.1.0-unstable-2026-11-20";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-mouse-touchpad";
    rev = "0a610607ad8ba204e4b4ac4549beb05b34c1fda2";
    hash = "sha256-48zzlJXoIfqK9pPcuIz5KdUAeAWNg2B5eKuL8zx71TQ=";
  };

  patches = [
    # Read the default touchegg.conf from the store rather than /usr/share
    (replaceVars ./fix-paths.patch {
      touchegg = touchegg;
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
    gala
    glib
    granite7
    gtk4
    libgee
    libxml2
    gnome-settings-daemon
    switchboard
    touchegg
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Mouse & Touchpad Plug";
    homepage = "https://github.com/elementary/settings-mouse-touchpad";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
