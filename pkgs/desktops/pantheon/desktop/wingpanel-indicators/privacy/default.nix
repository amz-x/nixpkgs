{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  gettext,
  pkg-config,
  meson,
  ninja,
  vala,
  glib,
  gtk4,
  granite7,
  wingpanel,
  libgee,
}:

stdenv.mkDerivation {
  pname = "wingpanel-indicator-privacy";
  version = "0-unstable-2026-09-22";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "wingpanel-indicator-privacy";
    rev = "19b1afc9f2ac0f1ba13653a2256263aa7516aea2";
    hash = "sha256-MVMiSh/CHYeW613nGGNTid5Y88JAjgwAY0d6i9QwUKM=";
  };

  patches = [
    # Upstream is still GTK 3, which current wingpanel can't load. Port it to
    # GTK 4, and replace bamf (X11 only) and lsof with reading /proc, mapping
    # camera users to apps through their systemd app scope.
    ./feature-port-to-gtk4.patch
  ];

  nativeBuildInputs = [
    gettext # msgfmt
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libgee
    wingpanel
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Privacy Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-privacy";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
