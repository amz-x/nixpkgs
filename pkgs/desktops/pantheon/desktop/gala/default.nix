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
  version = "8.6.1-unstable-2026-10-04"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    rev = "789076bd83fae351f17f390668d1c94a1f2f8253";
    hash = "sha256-pt9bfoyCWNlDJnU3XMuVDpGY2RNu6QtNVNx701sk4ec=";
  };

  patches = [
    # BackgroundContainer's destructor re-derives the monitor manager from
    # display/context/backend, which segfaults if the backend is already
    # mid-teardown -- as happens when gala's own process actually exits,
    # which normally only the greeter's gala instance does (once the user
    # logs in). Hold a proper reference instead of re-deriving it.
    ./fix-background-container-shutdown-crash.patch
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
