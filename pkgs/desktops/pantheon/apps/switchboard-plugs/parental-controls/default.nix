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
  version = "8.0.1-unstable-2026-11-22";

  # nixpkgs-update: no auto update
  src = fetchFromGitHub {
    owner = "elementary";
    repo = "switchboard-plug-parental-controls";
    rev = "7e2bc8cb5a4690482b15c4796dc693bb0cea528d";
    hash = "sha256-yUvXaj7fo6KafanaP62Hpl0S4JI/FL5aOwtMOc1RbIE=";
  };

  patches = [
    # See the nixos/lightdm module for corresponding PAM files.
    # Since we override conf file path we need to create time.conf ourselves.
    ./fix-create-pam-time-conf.patch

    # We cannot really setfacl on read-only desktop files.
    ./fix-disable-applications-tab.patch
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
