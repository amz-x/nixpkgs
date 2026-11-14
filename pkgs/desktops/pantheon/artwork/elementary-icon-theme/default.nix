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
  version = "9.0.0-unstable-2026-11-13";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = "8a839428ab618dfdb1f980557aae207ad4a79287";
    hash = "sha256-kJgx4lYvEMvwPpZxZYBFffU6Nb4Okjh068H8zP00ZYE=";
  };

  patches = [
    # ElementTree writes unregistered namespaces as ns0, ns1, ..., but GTK 4.22's
    # SVG parser only knows the literal xlink:href, so composited mimetype icons
    # lost their gradients and rendered blank
    ./fix-composite-svg-xlink-prefix.patch

    # elementary/icons#1461 removed rotation-allowed-symbolic as unused, but
    # actions/symbolic/system-reboot-symbolic.svg is still a symlink to it;
    # restore the target so the reboot icon isn't a dangling symlink
    ./fix-system-reboot-symbolic-target.patch
  ];

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
