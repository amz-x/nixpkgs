{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gnome-settings-daemon,
  gtk4,
  granite7,
  wingpanel,
  libnotify,
  pulseaudio,
  libcanberra,
  libgee,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-sound";
  version = "8.0.3-unstable-2026-09-01"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-sound";
    rev = "e6e33d9c68d3268ee8507ecfe5c2935872f736a4";
    hash = "sha256-7bXzcNYEziUCmfQNwZw7LvBTCclmcCf5btlszyWzF88=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    gnome-settings-daemon # media-keys
    granite7
    gtk4
    libcanberra
    libgee
    libnotify
    pulseaudio
    wingpanel
  ];

  # Upstream calls gnome.post_install(glib_compile_schemas: true) even though
  # this package doesn't ship any schemas, so the target directory needs to
  # exist before ninja install runs the post-install script
  preInstall = ''
    mkdir -p "$out/share/glib-2.0/schemas"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Sound Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-sound";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
