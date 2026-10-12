{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  gettext,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation {
  pname = "elementary-wallpapers";
  version = "8.0.0-unstable-2026-06-29"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wallpapers";
    rev = "f28b86144ba01d788ac61ad198ca16fa9477913f";
    sha256 = "sha256-wFcjyZ/caGM94QtB7Decy73u1rbYLMt73GUuJwMNvlg=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    python3
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs meson/symlink.py
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Collection of wallpapers for elementary";
    homepage = "https://github.com/elementary/wallpapers";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
