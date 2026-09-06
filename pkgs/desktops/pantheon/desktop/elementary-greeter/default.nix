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
  version = "8.1.2-unstable-2026-08-28"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "greeter";
    rev = "3364dba5393652684883f1194eafb6112f94f08a";
    hash = "sha256-YESyJzhGKhutTogKcaLtdFBtkjUt9ab1NpXaiqVUxVo=";
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

    # Application.activate() gets called repeatedly (roughly once a
    # second, for as long as the greeter runs), not just once at startup,
    # and had no guard against creating another MainWindow each time --
    # a runaway window leak that also visibly doubled (and kept
    # redoubling) the login UI on top of the above.
    ./fix-repeated-activate-window-leak.patch
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
    # PATH; gala itself now knows to spawn the login UI, session manager
    # shim, and settings daemon (see pantheon.gala's
    # spawn-greeter-clients.patch), so upstream's own gala-based Exec works.
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
