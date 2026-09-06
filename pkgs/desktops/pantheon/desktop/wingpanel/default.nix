{
  atk,
  colord,
  egl-wayland,
  elementary-gtk-theme,
  elementary-icon-theme,
  fetchFromGitHub,
  fetchpatch,
  fribidi,
  gala,
  gettext,
  glib,
  gnome-desktop,
  gnome-settings-daemon,
  gobject-introspection,
  granite7,
  gtk4,
  harfbuzz,
  json-glib,
  lcms2,
  lib,
  libcanberra,
  libdisplay-info,
  libdrm,
  libei,
  libgbm,
  libgee,
  libGL,
  libgudev,
  libinput,
  libstartup_notification,
  libsysprof-capture,
  libwacom,
  libx11,
  libxau,
  libxcb,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  meson,
  mutter,
  ninja,
  nix-update-script,
  pipewire,
  pixman,
  pkg-config,
  stdenv,
  systemd,
  vala,
  wayland-scanner,
  wayland,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "wingpanel";
  version = "8.0.4-unstable-2026-09-02"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel";
    rev = "9eda202f268adb70e89376063974a3f7895e095c";
    hash = "sha256-aDeY2GxQnz7nGEgs45FXrTWHS/Xdvo20TSnwJUpqSe8=";
  };

  patches = [
    # Wingpanel indicators patch for NixOS
    ./indicators.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    atk
    colord
    egl-wayland
    elementary-icon-theme
    fribidi
    gala
    gnome-desktop
    gnome-settings-daemon
    gobject-introspection
    granite7
    harfbuzz
    json-glib
    lcms2
    libcanberra
    libdisplay-info
    libdrm
    libei
    libgbm
    libgee
    libGL
    libgudev
    libinput
    libstartup_notification
    libsysprof-capture
    libwacom
    libx11
    libxau
    libxcb
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    mutter
    pipewire
    pixman
    systemd
    wayland
  ];

  propagatedBuildInputs = [
    glib
    gtk4
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # this GTK theme is required
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"

      # the icon theme is required
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extensible top panel for Pantheon";
    longDescription = ''
      Wingpanel is an empty container that accepts indicators as extensions,
      including the applications menu.
    '';
    homepage = "https://github.com/elementary/wingpanel";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.wingpanel";
  };
}
