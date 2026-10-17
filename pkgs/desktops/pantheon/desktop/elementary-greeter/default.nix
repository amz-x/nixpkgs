{
  accountsservice,
  dbus,
  desktop-file-utils,
  elementary-greeter,
  elementary-gtk-theme,
  elementary-icon-theme,
  elementary-settings-daemon,
  fetchFromGitHub,
  gala,
  gdk-pixbuf,
  gnome-desktop,
  gnome-settings-daemon,
  granite7,
  gtk3,
  gtk4,
  lcms2,
  lib,
  libadwaita,
  libgee,
  libhandy,
  libxkbcommon,
  lightdm,
  linkFarm,
  meson,
  mutter,
  ninja,
  nix-update-script,
  nixos-artwork,
  pkg-config,
  replaceVars,
  stdenv,
  vala,
  wayland-scanner,
  wingpanel-with-indicators,
  wrapGAppsHook4,
}:

stdenv.mkDerivation {
  pname = "elementary-greeter";
  version = "8.1.2-unstable-2026-10-13"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "greeter";
    rev = "2eb38368c78b7d35877c3493f627c9666db68cea";
    hash = "sha256-NfYAzd61qb60J2cYILQYyKCEaKchpXQ45Z+tITym9J0=";
  };

  patches = [
    # Needed to fix lightdm's configuration install file path
    ./sysconfdir-install.patch

    # Needed until https://github.com/elementary/greeter/issues/360 is actuallly fixed
    (replaceVars ./hardcode-fallback-background.patch {
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}";
    })

    # MainWindow.add_card() has no guard against re-adding a user that
    # already has a card, but load_users() reruns in full on every
    # Act.UserManager "user-added" signal (which fires once per user during
    # AccountsService enumeration, and potentially again later) -- so every
    # rerun duplicates every existing card in the carousel and leaks the
    # previous ones, causing runaway memory growth and visibly doubled
    # cards/buttons.
    ./fix-duplicate-user-cards-leak.patch

    # Removing the in-tree compositor also dropped the install of
    # data/compositor.gschema.xml, which still holds the io.elementary.greeter
    # schema used by the greeter (and leaves glib-compile-schemas in
    # post_install failing on a missing schemas directory).
    ./install-greeter-schema.patch
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    elementary-icon-theme
    elementary-settings-daemon
    gala # for io.elementary.desktop.background
    gdk-pixbuf
    gnome-desktop
    gnome-settings-daemon
    granite7
    gtk3
    gtk4
    lcms2
    libadwaita
    libgee
    libhandy
    libxkbcommon
    lightdm
    mutter
  ];

  mesonFlags = [
    # A hook does this but after wrapGAppsHook3 so the files never get wrapped.
    "--sbindir=${placeholder "out"}/bin"
    # baked into the program for discovery of the greeter configuration
    "--sysconfdir=/etc"
    "-Dgsd-dir=${gnome-settings-daemon}/libexec/" # trailing slash is needed
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # dbus-launch needed in path
      --prefix PATH : "${dbus}/bin"

      # for `io.elementary.wingpanel -g`
      --prefix PATH : "${wingpanel-with-indicators}/bin"

      # for the compositor
      --prefix PATH : "$out/bin"

      # the GTK theme is hardcoded
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"

      # the icon theme is hardcoded
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  postFixup = ''
    # Use the full path to gala so the greeter session doesn't depend on
    # PATH. With GALA_SESSION_TYPE=greeter, gala itself spawns the greeter's
    # clients (wingpanel -g, greeter session manager, the login UI and the
    # settings daemon) from the session-type=greeter entries of its own
    # io.elementary.desktop.wm.shell, so upstream's gala-based Exec works.
    substituteInPlace $out/share/xgreeters/io.elementary.greeter.desktop \
      --replace-fail "Exec=env GALA_SESSION_TYPE=greeter XDG_CURRENT_DESKTOP=Pantheon gala --wayland" \
                     "Exec=env GALA_SESSION_TYPE=greeter XDG_CURRENT_DESKTOP=Pantheon ${gala}/bin/gala --wayland"
  '';

  passthru = {
    updateScript = nix-update-script { };

    xgreeters = linkFarm "pantheon-greeter-xgreeters" [
      {
        path = "${elementary-greeter}/share/xgreeters/io.elementary.greeter.desktop";
        name = "io.elementary.greeter.desktop";
      }
    ];
  };

  meta = {
    description = "LightDM Greeter for Pantheon";
    homepage = "https://github.com/elementary/greeter";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.greeter";
  };
}
