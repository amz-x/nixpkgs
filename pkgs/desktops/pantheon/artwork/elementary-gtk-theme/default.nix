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
  version = "8.2.2-unstable-2026-07-30"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "stylesheet";
    rev = "ce649052e3b0a0aa3c61521f521aef434506d332";
    sha256 = "sha256-9XdAxOgx/rzjeiv6k4fHha9urAxUL7GK1b3frJrVUC0=";
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
