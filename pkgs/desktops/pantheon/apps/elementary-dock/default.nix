{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  wayland-scanner,
  wrapGAppsHook4,
  glib,
  granite7,
  gtk4,
  libadwaita,
  wayland,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-dock";
  version = "8.3.3-unstable-2026-11-06";

  outputs = [
    "out"
    "dev"
  ];

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "dock";
    rev = "72059a647efe49a9e897418e37c618d31239f71d";
    hash = "sha256-9rsABYfhepkc7HcbX8mBvoZLYLZB+/MOyW2k2lxaTXY=";
  };

  patches = [
    # Launcher: new context option to close all windows
    # https://github.com/elementary/dock/pull/344 (needs gala#2202)
    # Rebased: the PR targets files that have since moved and been reworked
    # (menu built in Launcher, desktop integration owned by WindowSystem).
    ./feature-close-all-windows.patch

    # Follow gala's D-Bus rename to io.elementary.gala
    # https://github.com/elementary/gala/pull/2046
    ./feature-gala-rdnn-dbus.patch

    # Launch applications inside a Systemd scope
    # https://github.com/elementary/dock/pull/464
    # Reworked to address review: D-Bus activated apps report pid 0 (the
    # lookup never fails), async D-Bus calls, also cover middle-click launches.
    ./feature-systemd-scope.patch

    # Upstream bug from 7db0fd51 ("Introduce AnimatableWidget and use
    # Adw.PropertyAnimationTarget"): AnimatableWidget allocated itself from its
    # property setters, outside the layout pass, so animations starting before
    # the first layout allocated 0x0 and spammed allocation warnings; allocate
    # the child with the transform in size_allocate () instead
    ./fix-animatable-widget-allocation.patch
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libadwaita
    wayland
  ];

  # Fix building with GCC 14
  # https://github.com/elementary/dock/issues/418
  env.NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Elegant, simple, clean dock";
    homepage = "https://github.com/elementary/dock";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.dock";
  };
})
