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
  gst_all_1,
  gtk4,
  libadwaita,
}:

stdenv.mkDerivation {
  pname = "elementary-music";
  version = "9.0.0-unstable-2026-11-04";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "music";
    rev = "16a202aa3ded530a45c324c3f26047f9d42295fa";
    hash = "sha256-i/IQ6FoSLZOViSAU6IKP28wVwSXmWv1DhGoi3W/5Buo=";
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
    libadwaita
  ]
  ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

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
    description = "Music player and library designed for elementary OS";
    homepage = "https://github.com/elementary/music";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.music";
  };
}
