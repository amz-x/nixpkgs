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
  version = "8.2.2-unstable-2026-11-09";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = "7c5f6967813ff106c08e52473aae465183c6decf";
    hash = "sha256-FdHQ6ex5INoKWc+vkXJzFJa+DhyWQiTaLu0eW2f+DDI=";
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
