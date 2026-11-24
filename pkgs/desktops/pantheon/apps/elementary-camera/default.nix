{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  glib,
  granite7,
  gst_all_1,
  gtk4,
  libadwaita,
  libcanberra,
  libgee,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "elementary-camera";
  version = "9.0.0-unstable-2026-11-21";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "camera";
    rev = "04c612a44286398c873e68f6a3938b5ebdf7f640";
    hash = "sha256-rsKNoKaD3RYIp/kBcanOQNDN3A+RX3BUqIPPJz3Wsxw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-rs # GTK 4 sink
    gst_all_1.gst-plugins-ugly
    gst_all_1.gstreamer
    gtk4
    libadwaita
    libcanberra
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Camera app designed for elementary OS";
    homepage = "https://github.com/elementary/camera";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.camera";
  };
}
