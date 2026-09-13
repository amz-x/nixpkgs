{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  libadwaita,
  libgee,
  granite7,
  gexiv2_0_10,
  gnome-settings-daemon,
  elementary-settings-daemon,
  gtk4,
  gala,
  wingpanel,
  wingpanel-indicator-keyboard,
  wingpanel-quick-settings,
  switchboard,
  gettext,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-pantheon-shell";
  version = "8.3.0-unstable-2026-09-04"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-desktop";
    rev = "b7c3c2a0a44fe79804e4b0c8dd84e5ed49339254";
    hash = "sha256-g5nm7LQmWEzzu4RLapqWwXXwZXsLVPiTl9+F8RLrAsw=";
  };

  # Fix crash when opening the Desktop settings page: upstream binds to a
  # gsettings key named "reduce-motion", but elementary-settings-daemon's
  # io.elementary.settings-daemon.a11y schema actually names the key
  # "reduced-motion", so g_settings_bind aborts with a fatal GLib error.
  # https://github.com/elementary/settings-desktop/blob/9a4d142c0381c0d54e71eac855d7fc8d640a0174/src/Views/Appearance.vala#L296
  postPatch = ''
    substituteInPlace src/Views/Appearance.vala \
      --replace-fail '"reduce-motion"' '"reduced-motion"'
  '';

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    gala
    gexiv2_0_10
    glib
    gnome-settings-daemon
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel
    wingpanel-indicator-keyboard # gsettings schemas
    wingpanel-quick-settings # gsettings schemas
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Desktop Plug";
    homepage = "https://github.com/elementary/settings-desktop";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
