{
  accountsservice,
  at-spi2-core,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  glycin-loaders,
  gnome-desktop,
  gnome-settings-daemon,
  granite,
  granite7,
  gtk3,
  gtk4,
  ibus,
  json-glib,
  lcms2,
  lib,
  libgee,
  libhandy,
  libxi,
  libxkbcommon,
  libxml2,
  libxslt,
  meson,
  mutter,
  systemdLibs,
  ninja,
  nix-update-script,
  pkg-config,
  sqlite,
  stdenv,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gala";
  version = "8.6.2-unstable-2026-10-30"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    rev = "991b2f15047c38d937273ce11375c333609ab5c5";
    hash = "sha256-Lm96P8XCSAcjUF8NVzzufFQSDTe9SuL78cuAANNjdN4=";
  };

  patches = [
    # DesktopIntegration: new method to close window used by dock
    # https://github.com/elementary/gala/pull/2202 (for elementary/dock#344)
    # Rebased: the PR diff targets src/DesktopIntegration.vala, which has
    # since moved to src/Misc/ and changed, so it doesn't apply as fetched.
    ./feature-desktop-integration-close-window.patch

    # Introduce a BrightnessManager DBus interface, since mutter 49+ removed
    # the gnome-settings-daemon backlight interface (for panel-power#301)
    # https://github.com/elementary/gala/pull/2916
    ./feature-brightness-manager.patch

    # BackgroundManager: Guard against actors that do not exist yet
    # https://github.com/elementary/gala/pull/2960
    ./fix-background-manager-guard-missing-actors.patch

    # Wingpanel closes its indicator popovers when it loses focus, but
    # clicking the wallpaper doesn't move focus, so unfocus the panel there
    ./fix-close-panel-popovers-on-background-click.patch

    # Gala still sends the input purpose to the OSK daemon when the daemon
    # appears, even if the OSK is disabled, which hit a requires () assertion;
    # and since #2964 skips it while disabled, resend it once enabled
    ./fix-osk-input-purpose-while-disabled.patch

    # BackgroundBlurEffect queued a repaint on every third paint, which with
    # buffer age damage kept the dock re-blurred on every unrelated frame;
    # only repaint the whole actor after a partial repaint
    ./fix-background-blur-redraw-loop.patch

    # The lock screen shield hides the cursor, so pointer events never reach
    # it and only a key press brought up the greeter; notice any input
    # through the idle monitor like gnome-shell's screen shield does
    ./fix-lock-screen-pointer-activity.patch

    # Move the D-Bus names from org.pantheon.gala to io.elementary.gala
    # https://github.com/elementary/gala/pull/2046
    # Regenerated: the PR no longer applies, and gala already owns the new name
    # for WindowDragProvider, so it's now owned once for both objects. Keep this
    # last, and in sync with the clients: wingpanel, dock, the display and
    # keyboard plugs, settings-daemon, portals and the keyboard indicator.
    ./feature-rdnn-dbus.patch
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    libxslt
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    at-spi2-core
    glycin-loaders
    gnome-desktop
    gnome-settings-daemon
    granite
    granite7
    gtk3 # daemon-gtk3
    gtk4
    ibus
    json-glib
    lcms2
    libgee
    libhandy
    libxi
    libxkbcommon
    mutter
    sqlite
    systemdLibs
  ];

  preFixup = ''
    # Needed for setting background images.
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "conf.set('PLUGINDIR', plugins_dir)" "conf.set('PLUGINDIR','/run/current-system/sw/lib/gala/plugins')"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Window & compositing manager based on mutter and designed by elementary for use with Pantheon";
    homepage = "https://github.com/elementary/gala";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "gala";
  };
})
