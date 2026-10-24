{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  sassc,
  vala,
  wrapGAppsHook4,
  appstream,
  dbus,
  flatpak,
  glib,
  granite7,
  gtk4,
  json-glib,
  libadwaita,
  libgee,
  libportal-gtk4,
  libsoup_3,
  libxml2,
  polkit,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "appcenter";
  version = "8.4.0-unstable-2026-10-17"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "appcenter";
    rev = "a2ddd36046e60fca49172d1f7fba87ad180c1122";
    hash = "sha256-AY0WLApSYXQtj9YiiYVvZzjZC89ShhMiRaC48sas0to=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sassc
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    appstream
    dbus
    flatpak
    glib
    granite7
    gtk4
    json-glib
    libadwaita
    libgee
    libportal-gtk4
    libsoup_3
    libxml2
    polkit
  ];

  mesonFlags = [
    "-Dpayments=false"
    "-Dcurated=false"
  ];

  postPatch = ''
    # Since we do not build libxml2 with legacy support,
    # we cannot use compressed appstream metadata.
    # https://gitlab.gnome.org/GNOME/libxml2/-/commit/f7f14537727bf6845d0eea08cd1fdc30accc2a53
    substituteInPlace src/Core/FlatpakBackend.vala \
      --replace-fail ".xml.gz" ".xml"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/elementary/appcenter";
    description = "Open, pay-what-you-want app store for indie developers, designed for elementary OS";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.appcenter";
  };
}
