{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "elementary-redacted-script";
  version = "5.1.0-unstable-2026-05-06"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "fonts";
    rev = "d45f566eeddb840c6ad9d74b7bd3b8daf83c066a";
    sha256 = "sha256-05Xddz4PT4fdP95w4WhRb7N51nnxv/fjRIcGPFDn0QA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  # Upstream's meson.build installs a symlink with a target path that is
  # only valid when sysconfdir is absolute (e.g. "/etc"). Since Nix's
  # sysconfdir is relative to $out, the symlink target resolves relative to
  # its own directory instead, producing a dangling symlink. Point it at
  # the sibling conf.avail directory instead.
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail \
      "pointing_to: conf_avail_dir / '31-croscore-elementary.conf'" \
      "pointing_to: '../conf.avail/31-croscore-elementary.conf'"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Font for concealing text";
    homepage = "https://github.com/elementary/fonts";
    license = lib.licenses.ofl;
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
}
