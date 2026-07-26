{ pkgs, ... }:

let
  pname = "nautilus-taildrop";
  version = "v1.1.0";
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);
in
  pkgs.stdenv.mkDerivation {
    inherit pname version;

    src = pkgs.fetchFromGitHub {
      owner = "Balazsmi";
      repo = pname;
      rev = version;
      sha256 = "sha256-7dB1quABOJFkQeg40PpNEVd0HorrXG9TeVSKiS5XhWk=";
    };

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.wrapGAppsHook4
    ];

    buildInputs = [
      pkgs.glib
      pkgs.gtk4
      pkgs.libadwaita
      pkgs.pango
      pkgs.gdk-pixbuf
      pkgs.adwaita-icon-theme
    ];

    installPhase = ''
      runHook preInstall

      install -Dm644 nautilus-taildrop.py \
        $out/share/nautilus-python/extensions/nautilus-taildrop.py

      install -Dm755 send-via-taildrop.py $out/bin/send-via-taildrop
      substituteInPlace $out/bin/send-via-taildrop \
        --replace "#!/usr/bin/env python3" "#!${pythonEnv}/bin/python3"

      install -Dm755 taildrop-auto-receive.sh $out/bin/taildrop-auto-receive

      install -Dm644 taildrop-auto-receive.service \
        $out/lib/systemd/user/taildrop-auto-receive.service

      substituteInPlace $out/lib/systemd/user/taildrop-auto-receive.service \
        --replace "%h/.local/bin/taildrop-auto-receive.sh" \
                  "$out/bin/taildrop-auto-receive"

      runHook postInstall
    '';

    postFixup = ''
      for prog in "$out/bin/send-via-taildrop" "$out/bin/taildrop-auto-receive"; do
        wrapProgram "$prog" \
          --suffix PATH : ${pkgs.lib.makeBinPath [ pkgs.tailscale ]} \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.libnotify pkgs.xdg-utils ]}
      done
    '';

    meta = with pkgs.lib; {
      description = "Tailscale Taildrop integration for GNOME's Nautilus";
      homepage = "https://github.com/Balazsmi/nautilus-taildrop";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      mainProgram = "send-via-taildrop";
    };
  }
