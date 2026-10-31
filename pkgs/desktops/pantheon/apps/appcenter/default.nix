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
  version = "8.4.0-unstable-2026-10-23"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "appcenter";
    rev = "dccedb873f13906b83d4f859396d39771d43504f";
    hash = "sha256-QFMQRGnHmIuSd7p8cG65acsj2g1uaHgMnpplDhcPUWg=";
  };

  patches = [
    # Screenshot.set_branding connected a closure capturing the package to
    # the Granite.Settings singleton, so every screenshot widget (and its
    # full-size texture) was kept alive forever.
    ./fix-screenshot-branding-leak.patch

    # AppInfoView/BackButton closures captured locals, creating reference
    # cycles through their own children: closed app pages were never freed.
    ./fix-page-reference-cycles.patch

    # realize can be emitted again after the page was unrealized; don't load
    # (and append) the description and screenshots a second time.
    ./fix-content-loaded-twice.patch

    # Screenshot widgets were created and their CSS providers registered from
    # a worker thread (GTK isn't thread-safe); load them in an async method
    # on the main thread instead, without the busy-wait loop.
    ./fix-load-screenshots-on-main-thread.patch

    # Skip video-only screenshots (no images) instead of passing NULL urls.
    ./fix-skip-video-only-screenshots.patch

    # libflatpak can emit operation-error with a NULL error (e.g. an update
    # that can't be resolved while offline) and segfaults dereferencing it if
    # the handler aborts; Vala's non-null lambda precondition made the handler
    # return "abort". Use a method taking a nullable error that continues the
    # transaction in that case.
    ./fix-flatpak-null-operation-error.patch

    # Every ActionStack keeps a ProgressButton on a hidden stack page, whose
    # progress bar runs the stylesheet's infinite calc() shimmer animation,
    # which GTK leaks memory on every frame of (megabytes per second while
    # idle). The shimmer only moves a plain-color background here, so disable it.
    ./fix-hidden-progressbar-animation-leak.patch

    # Flatpak transaction signal handlers captured the transaction (and the
    # progress objects) they were connected to, so no transaction was ever
    # freed. Each app page runs a dry-run transaction for the download size,
    # leaking the remote summary it maps (7.5 MB for Flathub) per page visit.
    ./fix-flatpak-transaction-leak.patch

    # CategoryView was never freed: its flowboxes held references back to
    # their owners through bind_model's create function (an instance method)
    # and the "Recently Updated" filter closure. Every category visited kept
    # its page, hundreds of app rows and their icons alive (~35 MB each).
    ./fix-category-view-leak.patch

    # The "Runtime Updates" entry is a plain Package, not a FlatpakPackage.
    # Opening it built an AddonFilter from it, whose package property then
    # stayed NULL, so filtering every package in the catalog printed a
    # get_installation assertion (thousands of journal lines per visit).
    # Package.hash dereferenced the same null cast.
    ./fix-runtime-updates-flatpak-casts.patch
  ];

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

  # Pages and AppStream reloads free hundreds of MB, which glibc keeps in
  # its free lists (and in per-thread arenas) instead of returning it, so
  # RSS only ever grows: 680 MB -> 1.4 GB over three rounds of browsing four
  # categories. Return free memory eagerly, mmap large allocations (unmapped
  # as soon as they are freed) and limit the number of arenas; with this RSS
  # stays flat at ~775 MB in the same test.
  preFixup = ''
    gappsWrapperArgs+=(
      --set-default GLIBC_TUNABLES "glibc.malloc.arena_max=2:glibc.malloc.trim_threshold=131072:glibc.malloc.mmap_threshold=131072"
    )
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
