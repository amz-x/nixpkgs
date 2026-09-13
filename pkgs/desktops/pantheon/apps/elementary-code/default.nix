{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  polkit,
  vala,
  wrapGAppsHook3,
  editorconfig-core-c,
  granite,
  gsettings-desktop-schemas,
  gtk3,
  gtksourceview4,
  gtkspell3,
  libgee,
  libgit2-glib,
  libhandy,
  libpeas2,
  libsoup_3,
  vte,
  ctags,
}:

stdenv.mkDerivation {
  pname = "elementary-code";
  version = "8.3.2-unstable-2026-09-03"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = "c7fea7ca9c4322f6d788e2b084977fcc697a3f9d";
    hash = "sha256-wsr0P/9AKyv5qXKpmxoQZOrhbR6cyjPpSD+vJfYNaAU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    polkit # needed for ITS rules
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    editorconfig-core-c
    granite
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    gtkspell3
    libgee
    libgit2-glib
    libhandy
    libpeas2
    libsoup_3
    vala # for ValaSymbolResolver provided by libvala
    vte
  ];

  # ctags needed in path by outline plugin
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ ctags ]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Code editor designed for elementary OS";
    homepage = "https://github.com/elementary/code";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.code";
  };
}
