{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "gnome-shell-extension-static-workspace-background";
  version = "51.0";

  src = pkgs.fetchFromGitHub {
    owner = "CleoMenezesJr";
    repo = "static-workspace-background";
    rev = "v${version}";
    hash = "sha256-xmw3jhilXS7uabYtBUwSLbEGZqqs/055rhmqvni0jKg=";
  };

  dontBuild = true;
  dontConfigure = true;

  passthru.extensionUuid = "static-workspace-background@CleoMenezesJr.github.io";

  installPhase = ''
    runHook preInstall

    install -Dm644 extension.js -t $out/share/gnome-shell/extensions/${passthru.extensionUuid}/
    install -Dm644 bounce.js -t $out/share/gnome-shell/extensions/${passthru.extensionUuid}/
    install -Dm644 metadata.json -t $out/share/gnome-shell/extensions/${passthru.extensionUuid}/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Keep a static background while changing workspaces in GNOME";
    homepage = "https://github.com/CleoMenezesJr/static-workspace-background";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
