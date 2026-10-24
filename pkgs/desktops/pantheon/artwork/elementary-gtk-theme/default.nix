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
  version = "8.2.2-unstable-2026-10-20"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = "64dea31d6711bdd2f53903ec8441a5f89ac0edd0";
    sha256 = "sha256-lEdVkzTGkbcEsV7aQBakURw/ZeMvMiYq4w/HVcI0jEw=";
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
