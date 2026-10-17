{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  imagemagick,
  gtk3,
  webkitgtk_4_1,
  glib-networking,
  gnupg,
  libnotify,
  xdg-utils,
}:

buildGoModule (finalAttrs: {
  pname = "pgp-manager";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "developaaah";
    repo = "pgp-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Nz1DwjMLkYbp1Yw4XbwYMXsjigKhZCH/ZGrOIl/I90=";
  };

  passthru.frontend = buildNpmPackage {
    pname = "pgp-manager-frontend";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs.src.name}/frontend";

    # Upstream does not commit a lockfile (yarn.lock is gitignored)
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-4pJM5k3i8sSDQIZMVqqmcnj9/BGo5/pnaDpUAgvDFt8=";

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';
  };

  vendorHash = "sha256-jQPyDkFGAzh508c8Ey4ClGsc31ujtMUZKtMLGWjvM7M=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    imagemagick
  ];

  buildInputs = [
    gtk3
    webkitgtk_4_1
    glib-networking
  ];

  tags = [
    "desktop"
    "production"
    "webkit2_41"
  ];

  # A version without the "v" prefix also disables the GitHub update check
  ldflags = [
    "-s"
    "-X main.appVersion=${finalAttrs.version}"
  ];

  preBuild = ''
    cp -r ${finalAttrs.passthru.frontend} frontend/dist
  '';

  postInstall = ''
    mv $out/bin/pgp-manager $out/bin/pgpmanager
    install -Dm644 build/linux/pgp-manager.desktop \
      $out/share/applications/com.developaaah.pgp-manager.desktop
    install -Dm644 build/linux/com.developaaah.pgp-manager.metainfo.xml \
      -t $out/share/metainfo
    for size in 16 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/''${size}x''${size}/apps
      magick build/appicon.png -resize ''${size}x''${size} \
        $out/share/icons/hicolor/''${size}x''${size}/apps/com.developaaah.pgp-manager.png
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --suffix PATH : ${
        lib.makeBinPath [
          gnupg
          libnotify
          xdg-utils
        ]
      }
    )
  '';

  meta = {
    description = "Modern OpenPGP key management and encryption desktop app";
    homepage = "https://github.com/developaaah/pgp-manager";
    changelog = "https://github.com/developaaah/pgp-manager/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amz-x ];
    mainProgram = "pgpmanager";
    platforms = lib.platforms.linux;
  };
})
