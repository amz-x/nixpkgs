{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  vala,
  gtk3,
  libexif,
  libgee,
  libhandy,
  libportal-gtk3,
  geocode-glib_2,
  gexiv2_0_16,
  libgphoto2,
  granite,
  gst_all_1,
  libgudev,
  libraw,
  sqlite,
  libwebp,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "elementary-photos";
  version = "8.0.2-unstable-2026-09-23";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "photos";
    rev = "58f178f7f9df3aa39a67ab4a6991afc3cb46d228";
    sha256 = "sha256-XXtVF26nrehCz56/xoYGAhntQGUPzSOECpy3uHHlA20=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    geocode-glib_2
    gexiv2_0_16
    granite
    gtk3
    libexif
    libgee
    libgphoto2
    libgudev
    libhandy
    libportal-gtk3
    libraw
    libwebp
    sqlite
  ]
  ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-ugly
    gstreamer
  ]);

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Photo viewer and organizer designed for elementary OS";
    homepage = "https://github.com/elementary/photos";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.photos";
  };
}
