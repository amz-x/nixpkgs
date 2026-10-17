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
  version = "8.6.2-unstable-2026-10-13"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    rev = "f54c9161cae24b479fa78e108122f7ec4fddaf77";
    hash = "sha256-aKaeamz9kT8M9fAijhSFf++ZuZFANV4SZ+O+4mbLJa4=";
  };

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
