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
  version = "8.0.3-unstable-2026-09-12"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-sound";
    rev = "8b7991c9156ac8127d27559506baea8e6fb72e5b";
    hash = "sha256-pre1cqMoQAIgWPYd7B10yADUNniRF69C7PjUp7lNgyY=";
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
