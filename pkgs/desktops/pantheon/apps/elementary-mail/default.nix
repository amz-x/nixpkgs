{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  vala,
  gtk3,
  gtk4,
  libxml2,
  libhandy,
  libportal-gtk3,
  webkitgtk_4_1,
  elementary-gtk-theme,
  elementary-icon-theme,
  folks,
  glib-networking,
  granite,
  evolution-data-server,
  wrapGAppsHook3,
  libgee,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "elementary-mail";
  version = "8.0.1-unstable-2026-10-25"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "mail";
    rev = "bccf78bf76c59ebbce03f6b64f0c77caedf7e5cd";
    hash = "sha256-U2eCqH+mlHGFOYf098pYhXapzVbvSLma+/qgrqbIF4s=";
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
  ];

  buildInputs = [
    elementary-icon-theme
    evolution-data-server
    folks
    glib-networking
    granite
    gtk3
    gtk4
    libgee
    libhandy
    libportal-gtk3
    webkitgtk_4_1
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # The GTK theme is hardcoded.
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
      # The icon theme is hardcoded.
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mail app designed for elementary OS";
    homepage = "https://github.com/elementary/mail";
    changelog = "https://github.com/elementary/mail/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = [ lib.teams.pantheon ];
    mainProgram = "io.elementary.mail";
  };
})
