{ lib, pkgs, ... }:

let
  extensions = [
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "jplgfhpmjnbigmhklmmbgecoobifkmpa" # ProtonVPN
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
    "gphhapmejobijbbhgpjhcjognlahblep" # GNOME Shell integration
  ];

  chromiumFeatures = [
    "AcceleratedVideoEncoder"
    "AcceleratedVideoDecodeLinuxGL"
    "AcceleratedVideoDecodeLinuxZeroCopyGL"
    "VaapiOnNvidiaGPUs"
    "VerticalTabs"
  ];

  mkUrl = name: url: {
    inherit name url;
    type = "url";
  };

  mkFolder = name: children: {
    inherit name children;
    type = "folder";
  };
in {
  programs.chromium = {
    enable = true;
    inherit extensions;

    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
    defaultSearchProviderSuggestURL = "https://duckduckgo.com{searchTerms}&type=list";

    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [ "en-GB" "ro" ];
      "AutofillAddressEnabled" = false;
      "AutofillCreditCardEnabled" = false;
      "PasswordLeakDetectionEnabled" = false;
      "EnableMediaRouter" = false;
      "BookmarkBarEnabled" = true;
      "ShowHomeButton" = false;

      # Disallow imperative extension installs
      "ExtensionInstallBlocklist" = [ "*" ];
      "ExtensionInstallAllowlist" = extensions;

      # mTLS convenience
      "AutoSelectCertificateForUrls" = [
        (builtins.toJSON {
          pattern = "https://[*.]heartblin.eu";
          filter.ISSUER.CN = "Reason-Root-CA";
        })
      ];
    };
  };

  environment.systemPackages = [
    (pkgs.chromium.override {
      commandLineArgs = [
        "--test-type" # Disables the warning about MiddleClickAutoscroll
        "--enable-blink-features=MiddleClickAutoscroll"
        "--enable-features=${lib.concatStringsSep "," chromiumFeatures}"
      ];
    })
  ];

  hjem.users.primaryUser.files.".config/chromium/Default/Bookmarks".text = builtins.toJSON {
    version = 1;
    checksum = "00000000000000000000000000000000"; # Whatever
    roots = {
      bookmark_bar = mkFolder "Bookmarks Bar" [
        (mkFolder "Selfhosted" [
          (mkUrl "Immich" "https://photos.heartblin.eu")
          (mkUrl "Jellyfin" "https://movies.heartblin.eu")
          (mkUrl "Scrutiny" "https://smart.heartblin.eu")
          (mkUrl "SFTPGo" "https://files.heartblin.eu")
          (mkUrl "Uptime" "https://uptime.heartblin.eu")
          (mkUrl "VaultWarden" "https://vault.heartblin.eu")
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
}
