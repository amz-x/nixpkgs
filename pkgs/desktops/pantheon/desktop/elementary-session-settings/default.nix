{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  desktop-file-utils,
  gettext,
  pkg-config,
  gnome-keyring,
  gnome-session,
  wingpanel,
  orca,
  gnome-settings-daemon,
  systemdLibs,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-session-settings";
  version = "8.1.0-unstable-2026-11-06";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    rev = "f71c78d6ff47650a79a1c50ec4a64df9b3f0443c";
    hash = "sha256-znZcBHR4ROGgYK4H8xgmqJCYcZevvLnC8gYGwFRmP/s=";
  };

  patches = [
    # See https://github.com/elementary/session-settings/issues/88 for gnome-keyring.
    ./fix-no-autostart.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gnome-keyring
    gnome-settings-daemon
    orca
    systemdLibs
  ];

  mesonFlags = [
    "-Dmimeapps-list=false"
    "-Ddetect-program-prefixes=true"
    # https://github.com/elementary/session-settings/issues/91
    "-Dx11=false"
    "--sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall = ''
    # our mimeapps patched from upstream to exclude:
    # * evince.desktop -> org.gnome.Evince.desktop
    mkdir -p $out/share/applications
    cp -av ${./pantheon-mimeapps.list} $out/share/applications/pantheon-mimeapps.list

    # absolute path patched sessions
    substituteInPlace $out/share/wayland-sessions/pantheon-wayland.desktop \
      --replace-fail "Exec=gnome-session" "Exec=${gnome-session}/bin/gnome-session" \
      --replace-fail "TryExec=io.elementary.wingpanel" "TryExec=${wingpanel}/bin/io.elementary.wingpanel"
  '';

  passthru = {
    updateScript = nix-update-script { };

    providedSessions = [
      "pantheon-wayland"
    ];
  };

  meta = {
    description = "Session settings for elementary";
    homepage = "https://github.com/elementary/session-settings";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
})
