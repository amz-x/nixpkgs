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
  version = "8.0.2-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-bluetooth";
    rev = "7efa18b301aa9c8f27b0437aa9e8b714601c6856";
    hash = "sha256-N/NsnNpje4z9ygMLFJELJ0SeUZxJy/YYiYTsRMXu3rs=";
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
