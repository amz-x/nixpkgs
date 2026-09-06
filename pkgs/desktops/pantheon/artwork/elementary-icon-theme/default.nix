{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  adwaita-icon-theme,
  hicolor-icon-theme,
  gtk3,
  xcursorgen,
  librsvg,
}:

stdenvNoCC.mkDerivation {
  pname = "elementary-icon-theme";
  version = "9.0.0-unstable-2026-08-26"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = "91a1b73f6ef3a4f6bf2ec4e933242e14c82524c0";
    hash = "sha256-aAKGmB6A5T5uf2hqGeTZmrI+LtA4CfQA7weO2UqlmMY=";
  };

  nativeBuildInputs = [
    gtk3
    librsvg
    meson
    ninja
    xcursorgen
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  mesonFlags = [
    "-Dvolume_icons=false" # Tries to install some icons to /
    "-Dpalettes=false" # Don't install gimp and inkscape palette files
  ];

  postFixup = "gtk-update-icon-cache $out/share/icons/elementary";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Named, vector icons for elementary OS";
    longDescription = ''
      An original set of vector icons designed specifically for elementary OS and its desktop environment: Pantheon.
    '';
    homepage = "https://github.com/elementary/icons";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
