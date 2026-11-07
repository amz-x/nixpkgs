{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "8.0.2-unstable-2026-11-05";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "photos";
    rev = "f8b50e333fb5e78bd6e52ceeade83e573de42f29";
    hash = "sha256-IUgU4i/I7x2w3vEOgwMnf3GzU2Y7wBGH3F6e8j6rgrI=";
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
