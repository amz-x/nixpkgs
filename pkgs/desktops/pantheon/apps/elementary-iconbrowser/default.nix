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
  version = "8.1.0-unstable-2026-10-08"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "iconbrowser";
    rev = "9c2363eacf150c8f2bb5fd9e2342b1dda5909463";
    hash = "sha256-VD+gJ8Fv0OOlGsqCSLD479Ap7EKccxDR6vY3bP/c3q8=";
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
