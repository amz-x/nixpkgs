{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  python3,
  sassc,
}:

stdenvNoCC.mkDerivation {
  pname = "elementary-gtk-theme";
  version = "8.2.2-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = "17a60e20bb4785db40d368c1e057c6a9cc13bf49";
    hash = "sha256-KU6IyBTX9n9h+v1InKz0hp3DGBc6s5FxRASvO2PoqFQ=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
    sassc
  ];

  postPatch = ''
    chmod +x meson/install-to-dir.py
    patchShebangs meson/install-to-dir.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GTK theme designed to be smooth, attractive, fast, and usable";
    homepage = "https://github.com/elementary/stylesheet";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
