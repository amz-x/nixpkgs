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
  version = "8.1.0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-datetime";
    rev = "70ec8660b3c94c12963191071cae6e15405ac936";
    hash = "sha256-IrV0TyJu3oqiWcjToM1/rVOC/UAbh1r4614TmgUPAxc=";
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
