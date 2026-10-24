{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  nix-update-script,
  gnome-power-manager,
  pkg-config,
  meson,
  ninja,
  vala,
  elementary-settings-daemon,
  gettext,
  gtk4,
  granite7,
  libgtop,
  libnotify,
  udev,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-power";
  version = "8.0.2-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-power";
    rev = "8a11cb2fe8f0848d05c60528c85273da4a014d0e";
    sha256 = "sha256-0nB4I3WK5Oct8ulRvJtlppbDNF96gfntD9I8KW+ZDU8=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      gnome_power_manager = gnome-power-manager;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    elementary-settings-daemon
    granite7
    gtk4
    libgee
    libgtop
    libnotify
    udev
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Power Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-power";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
