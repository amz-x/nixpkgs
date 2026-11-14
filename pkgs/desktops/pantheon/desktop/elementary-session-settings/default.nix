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
  version = "8.1.0-unstable-2026-11-12";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "session-settings";
    rev = "94e357bb65ffa11cc9ef064853aa7a3d1a18f9f9";
    hash = "sha256-w+cAtGld3eqeb0fAN8JS2etwZ/z8g1QmeKq2zSg1CEU=";
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
