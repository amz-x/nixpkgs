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
  version = "8.4.0-unstable-2026-10-06"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "code";
    rev = "07ba77be46b91318190a0cbd2331aef932c5e16a";
    hash = "sha256-9X8jLnA/b782qrupluufeeIk6FdCnULzDqfVKAPSUD0=";
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
