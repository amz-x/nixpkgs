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
  version = "8.1.0-unstable-2026-10-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-mouse-touchpad";
    rev = "22c53096f40b5210faecff5335a28534cda929a9";
    hash = "sha256-JdRvDNgymaYK4HA5rMNWbuZ7o+UWObaqFDHWso6J2vc=";
  };

  patches = [
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
