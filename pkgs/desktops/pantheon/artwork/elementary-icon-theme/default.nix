{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  adwaita-icon-theme,
  granite9,
  hicolor-icon-theme,
  gtk3,
  xcursorgen,
  librsvg,
}:

stdenvNoCC.mkDerivation {
  pname = "elementary-icon-theme";
  version = "9.0.0-unstable-2026-09-23"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = "420da53fa88f24d5c0da62dd82eee5b87b3ea55f";
    hash = "sha256-c5ljM28jiCm6WAYnymYFfIc0k3zQq5Rjmplg+Z7CLgg=";
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
    granite9
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
