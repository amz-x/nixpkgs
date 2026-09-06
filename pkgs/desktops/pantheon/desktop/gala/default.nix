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
  ninja,
  nix-update-script,
  pkg-config,
  sqlite,
  stdenv,
  systemd,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gala";
  version = "8.5.1-unstable-2026-09-04"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    rev = "a52cafe94ed748e132a3093eb17fb7980fc760b2";
    hash = "sha256-fD3jMjZSkesU2dTCMmYzHjFdYXfSWdq268CMmiVRf+A=";
  };

  patches = [
    # Upstream elementary-greeter execs gala directly as its Wayland
    # compositor, but unlike the old standalone greeter-compositor, gala
    # has no code to spawn the actual login UI as a trusted Wayland client
    # -- so nothing shows a login prompt. Do so ourselves, the same way
    # gala already launches gala-daemon and io.elementary.notifications.
    ./spawn-greeter-clients.patch

    # BackgroundContainer's destructor re-derives the monitor manager from
    # display/context/backend, which segfaults if the backend is already
    # mid-teardown -- as happens when gala's own process actually exits,
    # which normally only the greeter's gala instance does (once the user
    # logs in). Hold a proper reference instead of re-deriving it.
    ./fix-background-container-shutdown-crash.patch

    # PantheonShell's focus() (backing the pantheon-desktop-shell-v1
    # "focus" request wingpanel/indicators use to ask for keyboard focus)
    # passes Meta.Display.get_current_time(), which just returns a cached
    # timestamp that can go stale -- meta_display_set_input_focus() then
    # silently rejects the whole request if that timestamp is older than
    # the display's last_user_time (which keeps advancing on any input
    # anywhere, e.g. the user clicking into an unrelated application).
    # Use get_current_time_roundtrip() instead, which is never stale.
    ./fix-stale-focus-timestamp.patch
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
    systemd
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
