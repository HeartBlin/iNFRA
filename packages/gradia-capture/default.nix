{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "gnome-shell-extension-gradia-capture";
  version = "unstable-2026-08-18";

  src = pkgs.fetchFromGitHub {
    owner = "AlexanderVanhee";
    repo = "gradia-capture";
    rev = "master";
    hash = "sha256-73K60pfIqlJmCu+RqeCvDzQUh/9yW965FZ2ew54EKI8=";
  };

  nativeBuildInputs = [
    pkgs.glib
  ];

  dontConfigure = true;
  dontBuild = true;

  passthru.extensionUuid = "gradia-integration@alexandervanhee.github.io";

  installPhase = ''
    runHook preInstall

    extensionDir="$out/share/gnome-shell/extensions/${passthru.extensionUuid}"

    mkdir -p "$extensionDir"
    cp -r src/. "$extensionDir/"

    mkdir -p "$extensionDir/schemas"

    cp \
      schemas/org.gnome.shell.extensions.gradia-companion.gschema.xml \
      "$extensionDir/schemas/"

    glib-compile-schemas "$extensionDir/schemas"

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Enhances the GNOME screenshot tool with annotation features";
    homepage = "https://github.com/AlexanderVanhee/gradia-capture";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
