{
  atk,
  colord,
  egl-wayland,
  elementary-gtk-theme,
  elementary-icon-theme,
  fetchFromGitHub,
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
  version = "8.0.4-unstable-2026-10-29"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel";
    rev = "7a3cb891acdb1559bb82b38a1724712d639f2d11";
    hash = "sha256-vEQmZwyONKTIs8We6dPvVSv4xvxpuK6MZ/+AEpK8AgU=";
  };

  patches = [
    # Expose Caps/Num Lock state for the keyboard indicator, which can't
    # track it itself on Wayland since the panel never has keyboard focus
    ./feature-lock-state-interface.patch

    # Wingpanel indicators patch for NixOS
    ./fix-indicators.patch

    # Indicator popovers don't autohide since #740, so Escape never reaches
    # them; close the open indicator from the panel window instead
    ./fix-close-indicator-on-escape.patch

    # Follow gala's D-Bus rename to io.elementary.gala
    # https://github.com/elementary/wingpanel/pull/572
    # Regenerated: the PR doesn't cover the WMDBus proxy.
    ./feature-rdnn-dbus.patch
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
