{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  gettext,
  granite7,
  gtk4,
  bluez,
  elementary-bluetooth-daemon,
  switchboard,
  wingpanel-indicator-bluetooth,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-bluetooth";
  version = "8.0.2-unstable-2026-09-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-bluetooth";
    rev = "c8cad4c42ae85d6e8f443261888b6a2e55f6f739";
    hash = "sha256-mDIQYR45nZRGJllKFd8EA1oIf4CsIzmIeBXIYycRYrQ=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    bluez
    elementary-bluetooth-daemon # settings schema
    granite7
    gtk4
    libadwaita
    libgee
    switchboard
    wingpanel-indicator-bluetooth # settings schema
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Bluetooth Plug";
    homepage = "https://github.com/elementary/settings-bluetooth";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };

}
