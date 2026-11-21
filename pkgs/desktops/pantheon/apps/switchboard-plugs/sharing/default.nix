{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  elementary-bluetooth-daemon,
  libgee,
  gettext,
  granite7,
  gtk4,
  libadwaita,
  openssl,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-sharing";
  version = "8.0.3-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sharing";
    rev = "c23fcee9a5be3837bc07810a9942cc1c50d0c7c1";
    hash = "sha256-vm92VV5dfG+NIh4YfOXbzgWDbqAoXOW2rJ0qgqAdGQY=";
  };

  patches = [
    # Remote Desktop page backed by gnome-remote-desktop (RDP), a port of
    # https://github.com/elementary/settings-sharing/pull/60
    ./feature-remote-desktop.patch
  ];

  postPatch = ''
    # OpenSSL creates the Remote Desktop TLS certificate; it may not be on the session's PATH.
    # grdctl is left to PATH: the page is only shown when gnome-remote-desktop is installed.
    substituteInPlace src/Backend/RemoteDesktopManager.vala \
      --replace-fail 'OPENSSL = "openssl"' 'OPENSSL = "${lib.getExe openssl}"'
  '';

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-bluetooth-daemon
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Sharing Plug";
    homepage = "https://github.com/elementary/settings-sharing";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
