{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  gettext,
  glib,
  wrapGAppsHook4,
  dbus,
  fuse3,
  gtk4,
  libadwaita,
  libsecret,
  webkitgtk_6_0,
  exiftool,
  xdg-utils,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "proton-drive-linux";
  version = "v3.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "narrrl";
    repo = "proton-drive-linux";
    rev = finalAttrs.version;
    hash = "sha256-tmVRH4Cp3ukJPxeKlfU29bd0h8mtQ4fRr4Zye/YmLP8=";
  };

  cargoHash = "sha256-jzEWq4ut1TeHW6cF9NG9t/dvdrCozbZsfyi6g0g/qoU=";

  cargoBuildFlags = [
    "--bin=pdfs"
    "--bin=pdfs-tray"
    "--bin=pdfs-app"
    "--bin=pdfs-prompt"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    gettext
    glib
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    fuse3
    glib
    gtk4
    libadwaita
    libsecret
    webkitgtk_6_0
  ];

  dontUseCmakeConfigure = true;

  env = {
    CARGO_PROFILE_RELEASE_LTO = "false";
    PDFS_LOCALEDIR = "${placeholder "out"}/share/locale";
  };

  doCheck = false;

  postInstall = ''
    install -Dm644 packaging/io.narl.proton-drive-linux.desktop \
      -t $out/share/applications
    install -Dm644 packaging/io.narl.proton-drive-linux-tray.desktop \
      -t $out/etc/xdg/autostart
    install -Dm644 packaging/io.narl.proton-drive-linux.svg \
      -t $out/share/icons/hicolor/scalable/apps

    mkdir -p $out/lib/systemd/user
    substitute packaging/proton-drive.service $out/lib/systemd/user/proton-drive.service \
      --replace-fail /usr/bin/pdfs $out/bin/pdfs

    bash po/build.sh $out/share/locale
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # pdfs-tray and pdfs-app start each other and pdfs-prompt by name.
      --prefix PATH : $out/bin
      # exiftool: RAW thumbnails; xdg-open: opening files.
      # fusermount3 is deliberately not added: on NixOS it must come from the
      # setuid wrapper in /run/wrappers/bin, which is already on PATH.
      --suffix PATH : ${
        lib.makeBinPath [
          exiftool
          xdg-utils
        ]
      }
    )
  '';

  meta = {
    description = "Unofficial Proton Drive client with on-demand FUSE mount, CLI and GTK4 app";
    homepage = "https://github.com/narrrl/proton-drive-linux";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "pdfs-app";
  };
})
