{
  stdenv,
  lib,
  fetchFromGitHub,
  desktop-file-utils,
  gettext,
  libxml2,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  at-spi2-core,
  gnome-settings-daemon,
  gnome-desktop,
  granite,
  granite7,
  gtk3,
  gtk4,
  libgee,
  libhandy,
  mutter,
  sqlite,
  systemd,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gala";
  version = "8.4.0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "gala";
    rev = "59c2f983b24f1cc70c2785b2b440481b459d4774";
    hash = "sha256-R+6s09jvLJbuCSmtzrY3mLqM1o+SygNQZjLCIfddh8c=";
  };

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    at-spi2-core
    gnome-settings-daemon
    gnome-desktop
    granite
    granite7
    gtk3 # daemon-gtk3
    gtk4
    libgee
    libhandy
    mutter
    sqlite
    systemd
  ];

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
}
