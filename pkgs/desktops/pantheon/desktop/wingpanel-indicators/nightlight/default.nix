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
  wingpanel,
  libgee,
  libxml2,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-nightlight";
  version = "2.1.3-unstable-2026-06-22"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "panel-nightlight";
    rev = "f226c2e6f7b1a1d39018101e515c61af69260ebd";
    sha256 = "sha256-3Eh03QEyKQnYSK6LxVHxMbDcv2Akx/Uu72Hs02s/5GY=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    granite7
    gtk4
    libgee
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Night Light Indicator for Wingpanel";
    homepage = "https://github.com/elementary/panel-nightlight";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
