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
  granite7,
  gtk4,
  libgee,
}:

stdenv.mkDerivation {
  pname = "elementary-calculator";
  version = "8.0.1-unstable-2026-08-17"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "calculator";
    rev = "6dc5b6dbb3dd5b0011a8d0a53d8ce0cf1595c255";
    sha256 = "sha256-Tx5eN+bL8AiOWkRE7nH2mmjnUoMf1w1BVfuPKBvzguc=";
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
    granite7
    gtk4
    libgee
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
    homepage = "https://github.com/elementary/calculator";
    description = "Calculator app designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.calculator";
  };
}
