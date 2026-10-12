{
  stdenv,
  lib,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  gdk-pixbuf,
  granite7,
  gst_all_1,
  gtk4,
  libadwaita,
  libgee,
}:

stdenv.mkDerivation {
  pname = "elementary-videos";
  version = "8.0.2-unstable-2026-10-11"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = "f7956200171c053a6d811f326a2561bc99a74a19";
    hash = "sha256-cjp8IroePkFc+MsgGsuigmEilFmmUiOFMtpt/PBmN6M=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gdk-pixbuf
    granite7
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    # https://github.com/elementary/videos/issues/356
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-rs # GTK 4 Sink
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Video player and library app designed for elementary OS";
    homepage = "https://github.com/elementary/videos";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.videos";
  };
}
