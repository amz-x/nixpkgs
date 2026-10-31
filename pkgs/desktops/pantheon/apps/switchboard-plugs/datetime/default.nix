{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  replaceVars,
  pkg-config,
  vala,
  libadwaita,
  libgee,
  libical,
  granite7,
  gettext,
  gtk4,
  libxml2,
  switchboard,
  tzdata,
}:

stdenv.mkDerivation {
  pname = "switchboard-plug-datetime";
  version = "8.1.0-unstable-2026-10-27"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-datetime";
    rev = "70be7ebb8d7a6df860397392a37e4c506e5d9c13";
    hash = "sha256-9cg8oPC73whfZgvR1FhKAAvx8sdjkuEG1LhZlveRKYg=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      tzdata = tzdata;
    })
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libadwaita
    libgee
    libical
    switchboard
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Date & Time Plug";
    homepage = "https://github.com/elementary/switchboard-plug-datetime";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
