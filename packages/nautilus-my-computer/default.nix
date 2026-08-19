{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "nautilus-my-computer";
  version = "0.13.1";

  src = pkgs.fetchFromGitHub {
    owner = "yannmasoch";
    repo = "nautilus-my-computer";
    rev = "v${version}";
    hash = "sha256-PPsUs6l1eg0mBiiAaJEi0/bf5cy58G7H/wHOqOhqeec=";
  };

  nativeBuildInputs = [
    pkgs.gettext
    pkgs.glib
    pkgs.python3
  ];

  buildInputs = [
    pkgs.libadwaita
    pkgs.nautilus-python
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    pyCairoPath=${pkgs.python3Packages.pycairo}/${pkgs.python3.sitePackages}
    mainFile="$out/share/nautilus-python/extensions/nautilus_my_computer/main.py"
    sed -i '/^from __future__/a import sys; sys.path.insert(0, "'"$pyCairoPath"'")' "$mainFile"
  '';

  postFixup = ''
    if [ -d "$out/share/gsettings-schemas" ]; then
      mkdir -p "$out/share/glib-2.0"
      mv "$out"/share/gsettings-schemas/*/glib-2.0/schemas "$out/share/glib-2.0/schemas"
      rm -rf "$out/share/gsettings-schemas"
    fi
  '';

  meta = {
    description = "My Computer for Nautilus, what GNOME Files should have always been";
    homepage = "https://github.com/yannmasoch/nautilus-my-computer";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.linux;
  };
}
