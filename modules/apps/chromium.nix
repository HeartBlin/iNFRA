{ inputs, pkgs, lib, ... }:

let
  prodVersion = "151.0.7922.137"; # Whatever is recent enough

  baseUrl = id:
    "https://clients2.google.com/service/update2"
    + "/crx?response=redirect&acceptformat=crx2,crx3"
    + "&prodversion=${prodVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";

  extensionFiles =
    lib.mapAttrs' (
      id: { version, hash, url ? baseUrl id }: let
        crx = pkgs.fetchurl { inherit hash url; };
      in
        lib.nameValuePair ".config/chromium/External Extensions/${id}.json" {
          text = builtins.toJSON {
            external_crx = crx;
            external_version = version;
          };
        }
    )
    extensions;

  extensions = {
    # Bitwarden
    "nngceckbapebfimnlniiiahkandclblb" = {
      version = "2026.7.0";
      hash = "sha256-PwXLkgGS9YjvBRUHgwiEtqiXkXmWngv3xA4Boqj9f74=";
    };

    # ProtonVPN
    "jplgfhpmjnbigmhklmmbgecoobifkmpa" = {
      version = "1.3.6";
      hash = "sha256-vTwPXkBKlOA0FUzaQTD1hldFzMevtSf41IHl2zkmQa0=";
    };

    # uBlock Origin
    "cjpalhdlnbpafiamejdnhcphjbkeiagm" = {
      version = "1.73.0";
      hash = "sha256-am9BiDyrsTDQCNXazBGIKEkMJwE3ZbNRiSR+i+oXg5E=";
    };

    # GNOME Shell integration
    "gphhapmejobijbbhgpjhcjognlahblep" = {
      version = "12.1";
      hash = "sha256-J2He45kRAn78643/aH9+cxeyCZ1CEKZjkeOSVt63jN4=";
    };

    # Chromium Web Store: Update notifier really
    "ocaahdebbfolfmndjeplogmgcagdmblk" = {
      version = "1.5.5.3";
      hash = "sha256-MmRDuuw9IEsTWOumqgJc9r2TDAiguY9nhOejI2UoRFs=";
      url = "https://github.com/NeverDecaf/chromium-web-store/releases/download/v1.5.5.3/Chromium.Web.Store.crx";
    };
  };

  mkUrl = name: url: {
    inherit name url;
    type = "url";
  };

  mkFolder = name: children: {
    inherit name children;
    type = "folder";
  };

  chromiumFeatures = [
    "AcceleratedVideoEncoder"
    "AcceleratedVideoDecodeLinuxGL"
    "AcceleratedVideoDecodeLinuxZeroCopyGL"
    "VaapiOnNvidiaGPUs"
    "VerticalTabs"
  ];
in {
  environment.systemPackages = [
    (pkgs.ungoogled-chromium.override {
      commandLineArgs = [
        "--test-type" # Disables the warning about MiddleClickAutoscroll
        "--enable-blink-features=MiddleClickAutoscroll"
        "--enable-features=${lib.concatStringsSep "," chromiumFeatures}"
      ];
    })
  ];

  programs.chromium = {
    enable = true;

    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://www.google.com/search?q={searchTerms}";
    defaultSearchProviderSuggestURL = "https://www.google.com/complete/search?output=chrome&q={searchTerms}";

    extraOpts = {
      PasswordManagerEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      EnableMediaRouter = false;
      SpellcheckEnabled = true;
      SpellcheckLanguage = [ "en-GB" "ro" ];
      BookmarkBarEnabled = true;
      ShowHomeButton = false;

      ExtensionInstallBlocklist = [ "*" ];
      ExtensionInstallAllowlist = builtins.attrNames extensions;
      ExtensionSettings = {
        "nngceckbapebfimnlniiiahkandclblb"."toolbar_pin" = "force_pinned";
        "jplgfhpmjnbigmhklmmbgecoobifkmpa"."toolbar_pin" = "force_pinned";
        "ocaahdebbfolfmndjeplogmgcagdmblk"."toolbar_pin" = "force_pinned";
      };

      "AutoSelectCertificateForUrls" = [
        (builtins.toJSON {
          pattern = "https://[*.]${inputs.stigmata.constants.domain}";
          filter.ISSUER.CN = "Reason CA Intermediate CA";
        })
      ];
    };
  };

  hjem.users.primaryUser.files =
    extensionFiles
    // {
      ".config/chromium/Default/Bookmarks".text = builtins.toJSON {
        version = 1;
        checksum = "00000000000000000000000000000000"; # Whatever
        roots = {
          bookmark_bar = mkFolder "Bookmarks Bar" [
            (mkFolder "Selfhosted" [
              (mkUrl "Immich" "https://photos.${inputs.stigmata.constants.domain}")
              (mkUrl "Jellyfin" "https://movies.${inputs.stigmata.constants.domain}")
              (mkUrl "Scrutiny" "https://smart.${inputs.stigmata.constants.domain}")
              (mkUrl "SFTPGo" "https://files.${inputs.stigmata.constants.domain}")
              (mkUrl "Uptime" "https://uptime.${inputs.stigmata.constants.domain}")
              (mkUrl "VaultWarden" "https://vault.${inputs.stigmata.constants.domain}")
            ])

            (mkFolder "Misc" [
              (mkUrl "Mailbox" "https://app.mailbox.org")
              (mkUrl "YouTube" "https://youtube.com")
              (mkUrl "GitHub" "https://github.com")
              (mkUrl "Teams" "https://teams.microsoft.com/v2/")
            ])

            (mkFolder "Nix" [
              (mkUrl "Functions" "https://noogle.dev/")
              (mkUrl "Options" "https://search.nixos.org/options")
              (mkUrl "Packages" "https://search.nixos.org/packages")
            ])
          ];
          other = mkFolder "Other Bookmarks" [ ];
          synced = mkFolder "Mobile Bookmarks" [ ];
        };
      };
    };
}
