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
  version = "9.0.0-unstable-2026-10-28"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "videos";
    rev = "37340111889e1c22d0a86de7ac2f2f78c58dd1f1";
    hash = "sha256-M435c/hoM8Q6clSL+XO8YrvQPAHF0lGczyRTxU7+tPw=";
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
