{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  elementary-gtk-theme,
  elementary-icon-theme,
  glib,
  granite7,
  gtk4,
  gtksourceview5,
}:

stdenv.mkDerivation {
  pname = "elementary-iconbrowser";
  version = "8.1.0-unstable-2026-08-24";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "iconbrowser";
    rev = "3125139d399c67c3c0c48bcbf007c2dc3c71f744";
    sha256 = "sha256-8QgtIjfpYwRzAAuZtSoaaATZaA0jZeN7/Pnpa/KP1AI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    elementary-icon-theme
    glib
    granite7
    gtk4
    gtksourceview5
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/iconbrowser";
    description = "Browse and find system icons";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.iconbrowser";
  };
}
