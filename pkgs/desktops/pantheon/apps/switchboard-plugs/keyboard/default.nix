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
  elementary-settings-daemon,
  libadwaita,
  libgee,
  gettext,
  gnome-settings-daemon,
  granite7,
  gsettings-desktop-schemas,
  gtk4,
  libxml2,
  libgnomekbd,
  libxklavier,
  ibus,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-keyboard";
  version = "8.1.1-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-keyboard";
    rev = "2bc471f718ab784c80365dff3a6d0645d2cbf0a1";
    hash = "sha256-5PTcJVKRdH5gMtTyE92mndniZPngBjNPB4KNpSkWVxw=";
  };

  patches = [
    # Follow gala's D-Bus rename to io.elementary.gala
    # https://github.com/elementary/gala/pull/2046
    ./feature-gala-rdnn-dbus.patch

    # This will try to install packages with apt.
    # https://github.com/elementary/settings-keyboard/issues/324
    ./fix-hide-install-unlisted-engines-button.patch

    # Launch gkbd-keyboard-display from the store for the add layout dialog's
    # keyboard map button, since libgnomekbd isn't on PATH in the session.
    (replaceVars ./fix-paths.patch {
      inherit libgnomekbd;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon # io.elementary.settings-daemon.applications
    gnome-settings-daemon # media-keys
    granite7
    gsettings-desktop-schemas
    gtk4
    ibus
    libadwaita
    libgee
    libxklavier
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Keyboard Plug";
    homepage = "https://github.com/elementary/settings-keyboard";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
