{
  lib,
  stdenv,
  callPackage,
  # Linux only, forwarded so `proton-vpn.override` reaches linux.nix
  withIndicator ? true,
  withSplitTunneling ? false,
}:
let
  meta = {
    description = "Official Proton VPN client";
    homepage = "https://protonvpn.com/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      anthonyroussel
      delafthi
      rapiteanu
    ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit meta; }
else
  callPackage ./linux.nix { inherit meta withIndicator withSplitTunneling; }
