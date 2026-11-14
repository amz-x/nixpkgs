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
  version = "8.1.0-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-mouse-touchpad";
    rev = "fd759322ada647570d1920b55a7a9eff214046b6";
    hash = "sha256-tn13YQbiuZOwF2qoNOiLeInp8zlKQmC5siECA5SZVUY=";
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
