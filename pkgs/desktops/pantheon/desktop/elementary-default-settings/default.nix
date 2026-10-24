{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  nixos-artwork,
  glib,
  pkg-config,
  accountsservice,
  dbus,
  polkit,
  systemdLibs
}:

stdenv.mkDerivation {
  pname = "elementary-default-settings";
  version = "8.1.1-unstable-2026-10-13"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = "915d1a0b63865ce3f0d44a68318d55ef9ca90fe6";
    hash = "sha256-OuCad68xQYGunYidDnYXPOBckysqSpiuBvSG16ubS6s=";
  };

  nativeBuildInputs = [
    glib # glib-compile-schemas
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    accountsservice
    dbus
    polkit
    systemdLibs
  ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"
    # Do not ship elementary OS specific config files.
    "-Dapparmor-profiles=false"
    "-Dgeoclue=false"
  ];

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -r $out/share/cups
    rm -r $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
