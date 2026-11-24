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
  cups,
  switchboard,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-printers";
  version = "8.0.2-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-printers";
    rev = "39ab29977cb06af4871a81be308d87b3e9d354a9";
    hash = "sha256-efdzhVu8uPNOU801uM/9sKYO5SNyMRbGQeePRIhgwzg=";
  };

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    cups
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
    description = "Switchboard Printers Plug";
    homepage = "https://github.com/elementary/settings-printers";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
