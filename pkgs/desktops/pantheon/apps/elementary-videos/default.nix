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

stdenv.mkDerivation rec {
  pname = "elementary-videos";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    tag = version;
    hash = "sha256-a6KV3F/18CkAc810WhZUvu/5wLi3bhi/Y8MBSwah5eU=";
  };

  patches = [
    # Closing the nested audio/subtitle combobox popup drops the settings
    # popover's autohide grab (GTK < 4.24), so it no longer closes on outside
    # clicks; close the popover with it like switchboard-plug-display does.
    ./fix-settings-popover-autohide.patch
    # Escape quit the app (Ctrl+Q already does) and, being handled on key
    # release, also fired after closing a popover or clearing the search entry.
    # Escape now leaves fullscreen, or otherwise goes back to the library.
    ./fix-escape-closing-popovers-quitting.patch
  ];

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
