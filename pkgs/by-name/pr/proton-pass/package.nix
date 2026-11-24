{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:
let
  pname = "proton-pass";
  # Proton sometimes ships the Linux and macOS builds on different days.
  linuxVersion = "1.43.1";
  darwinVersion = "1.43.0";
  version = if stdenv.hostPlatform.isDarwin then darwinVersion else linuxVersion;

  passthru = {
    inherit linuxVersion darwinVersion;
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://proton.me/download/pass/linux/x64/proton-pass_${linuxVersion}_amd64.deb";
        hash = "sha256-8iOJiqZdTa3vjbIJ/o2+AxIJYO3RQCYgrrMqo1kdcGI=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://proton.me/download/pass/macos/ProtonPass_${darwinVersion}.dmg";
        hash = "sha256-+dtkShLEgeG3/iNf+xFA5LTKNuVKUC/lcZLcA9Dulyc=";
      };
    };
    updateScript = writeShellScript "update-proton-pass" ''
      set -o errexit
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      latest() {
        curl --silent "https://proton.me/download/PassDesktop/$1/version.json" \
          | jq -r '[.Releases[] | select(.CategoryName == "Stable")] | first | .Version'
      }
      update() {
        if [[ -z "$4" || "$4" = null ]]; then
          echo "$1: couldn't read the latest version" >&2
          exit 1
        elif [[ "$3" = "$4" ]]; then
          echo "$1: already at $3"
        else
          update-source-version proton-pass "$4" --version-key="$2" --source-key="sources.$1"
        fi
      }
      update x86_64-linux linuxVersion ${linuxVersion} "$(latest linux/x64)"
      update aarch64-darwin darwinVersion ${darwinVersion} "$(latest macos)"
    '';
  };

  meta = {
    description = "Desktop application for Proton Pass";
    homepage = "https://proton.me/pass";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      massimogengarelli
      shunueda
    ];
    platforms = builtins.attrNames passthru.sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "proton-pass";
  };
in
callPackage (if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit
    pname
    version
    passthru
    meta
    ;
}
