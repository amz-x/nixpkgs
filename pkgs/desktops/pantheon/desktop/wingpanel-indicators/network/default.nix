{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk4,
  granite7,
  networkmanager,
  polkit,
  libnma-gtk4,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-network";
  version = "8.0.1-unstable-2026-08-28"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-network";
    rev = "82cdad09cd8f19adbe0097f8c4de8b4bd8f6b4cd";
    hash = "sha256-yOllt3pkW6DmUUH12t/tDt9ayvR/eIP3RqysMFavR+8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libgee
    networkmanager
    polkit
    libnma-gtk4
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Network Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-network";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
