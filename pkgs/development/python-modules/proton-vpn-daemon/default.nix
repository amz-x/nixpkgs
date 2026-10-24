{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bcc,
  coreutils,
  dbus-fast,
  packaging,
  proton-core,
  proton-vpn-api-core,
  psutil,
  python,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  systemd-python,
}:

buildPythonPackage rec {
  pname = "proton-vpn-daemon";
  version = "0.13.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "proton-vpn-daemon";
    tag = "v${version}";
    hash = "sha256-0aHY0aYgEf2OWGcH8ugJSH7viJ9zdf/wTgeb5nkxj6g=";
  };

  patches = [
    # Already running processes report their resolved exe (/nix/store/...-foo/bin/.foo-wrapped,
    # or the interpreter for protonvpn-app), which never matches configured paths like
    # /run/current-system/sw/bin/foo. In include mode this splits the app's own local agent
    # connection out of the VPN.
    ./split-tunneling-nix-paths.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    bcc
    dbus-fast
    packaging
    proton-core
    proton-vpn-api-core
    psutil
    systemd-python
  ];

  # Needed for `pythonImportsCheck`, `postBuild` happens between `pythonImportsCheckPhase` and `pytestCheckPhase`.
  postBuild = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  postInstall = ''
    # Upstream starts the daemon with `python3 -m proton.vpn.daemon`; provide a
    # script that wrapPythonPrograms can give the right PYTHONPATH.
    mkdir -p $out/bin $out/share/dbus-1/system-services $out/lib/systemd/system
    cat > $out/bin/proton-vpn-daemon <<EOF
    #!${python.interpreter}
    from proton.vpn.daemon.__main__ import run_forever
    run_forever()
    EOF
    chmod +x $out/bin/proton-vpn-daemon

    install -Dm644 rpmbuild/SOURCES/dbus.conf \
      $out/share/dbus-1/system.d/me.proton.vpn.split_tunneling.conf
    # Upstream points SystemdService at a unit name it never installs.
    substitute rpmbuild/SOURCES/dbus.service \
      $out/share/dbus-1/system-services/me.proton.vpn.split_tunneling.service \
      --replace-fail /bin/false ${coreutils}/bin/false \
      --replace-fail SystemdService=proton.VPN.service SystemdService=me.proton.vpn.split_tunneling.service
    substitute rpmbuild/SOURCES/systemd.service \
      $out/lib/systemd/system/me.proton.vpn.split_tunneling.service \
      --replace-fail "/usr/bin/python3 -m proton.vpn.daemon" "$out/bin/proton-vpn-daemon"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "proton.vpn.daemon"
    "proton.vpn.daemon.split_tunneling"
  ];

  meta = {
    description = "Daemons for Proton VPN Linux client";
    homepage = "https://github.com/ProtonVPN/proton-vpn-daemon";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
