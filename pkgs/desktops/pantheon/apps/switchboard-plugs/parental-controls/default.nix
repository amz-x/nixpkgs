{
  stdenv,
  lib,
  fetchFromGitHub,
  gettext,
  gtk4,
  meson,
  ninja,
  pkg-config,
  vala,
  wrapGAppsHook4,
  accountsservice,
  dbus,
  flatpak,
  glib,
  granite7,
  libadwaita,
  libgee,
  malcontent,
  polkit,
  switchboard,
  systemdLibs,
  iptables,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "switchboard-plug-parental-controls";
  version = "8.0.1-unstable-2026-10-24"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-parental-controls";
    rev = "6f800d8db5b492648038e292cd292601c1a56dc7";
    hash = "sha256-FHj2DspNr90AL5qWTVbALMmRg5gvkdrB5+/U8Ienmik=";
  };

  patches = [
    # See the nixos/lightdm module for corresponding PAM files.
    # Since we override conffile path we need to create time.conf ourselves.
    ./create-pam-time-conf.patch

    # We cannot really setfacl on read-only desktop files.
    ./disable-applications-tab.patch
  ];

  nativeBuildInputs = [
    gettext
    gtk4 # gtk4-update-icon-cache
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    accountsservice
    dbus
    flatpak
    glib
    granite7
    gtk4
    libadwaita
    libgee
    malcontent
    polkit
    switchboard
    systemdLibs
  ];

  mesonFlags = [
    # For /var/lib/pantheon-parental-controls/daemon.conf
    "-Dsharedstatedir=/var/lib"
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dsystemduserunitdir=${placeholder "out"}/share/systemd/user"
  ];

  preFixup = ''
    # For WebRestriction.
    gappsWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ iptables ]})
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Switchboard Screen Time & Limits Plug";
    homepage = "https://github.com/elementary/switchboard-plug-parental-controls";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
})
