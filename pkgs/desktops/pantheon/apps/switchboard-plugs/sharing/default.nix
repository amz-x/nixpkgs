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
  gnutls,
  granite7,
  gtk4,
  libadwaita,
  libsecret,
  switchboard,
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "8.0.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-sharing";
    tag = version;
    hash = "sha256-TNLnSFvjJFUfDkhYSKgqgpmpZggIw3LcBqmkXIzZ3nk=";
  };

  patches = [
    # Remote Desktop page backed by gnome-remote-desktop (RDP), a port of
    # https://github.com/elementary/settings-sharing/pull/60
    ./remote-desktop.patch
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-bluetooth-daemon
    gnutls
    granite7
    gtk4
    libadwaita
    libgee
    libsecret
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
