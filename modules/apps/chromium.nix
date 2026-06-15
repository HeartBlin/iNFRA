{ lib, pkgs, ... }:

let
  extensions = [
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "jplgfhpmjnbigmhklmmbgecoobifkmpa" # ProtonVPN
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
  ];
in {
  programs.chromium = {
    enable = true;
    inherit extensions;
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
    };
  };

  environment.systemPackages = [
    (pkgs.chromium.override {
      commandLineArgs = [
        "--test-type" # Disables the complaint about MiddleClickAutoscroll at start
        "--enable-blink-features=MiddleClickAutoscroll"
        "--enable-features=${lib.concatStringsSep "," [
          "AcceleratedVideoEncoder"
          "AcceleratedVideoDecodeLinuxGL"
          "AcceleratedVideoDecodeLinuxZeroCopyGL"
          "VaapiOnNvidiaGPUs"
        ]}"
      ];
    })
  ];

  hjem.users.primaryUser.files.".config/chromium/Default/Bookmarks".text = builtins.toJSON {
    "version" = 1;
    "checksum" = "00000000000000000000000000000000"; # Whatever
    "roots" = {
      "bookmark_bar" = {
        "name" = "Bookmarks Bar";
        "type" = "folder";
        "children" = [
          {
            "name" = "Selfhosted";
            "type" = "folder";
            "children" = [
              {
                "name" = "Immich";
                "url" = "https://photos.heartblin.eu";
                "type" = "url";
              }
              {
                "name" = "Jellyfin";
                "url" = "https://movies.heartblin.eu";
                "type" = "url";
              }
              {
                "name" = "Scrutiny";
                "url" = "https://scrutiny.heartblin.eu";
                "type" = "url";
              }
              {
                "name" = "VaultWarden";
                "url" = "https://vault.heartblin.eu";
                "type" = "url";
              }
            ];
          }
          {
            "name" = "YouTube";
            "url" = "https://youtube.com";
            "type" = "url";
          }
          {
            "name" = "GitHub";
            "url" = "https://github.com";
            "type" = "url";
          }
          {
            "name" = "Teams";
            "url" = "https://teams.microsoft.com/v2/";
            "type" = "url";
          }
          {
            "name" = "Options";
            "url" = "https://search.nixos.org/options";
            "type" = "url";
          }
          {
            "name" = "Packages";
            "url" = "https://search.nixos.org/packages";
            "type" = "url";
          }
        ];
      };
      "other" = {
        "name" = "Other Bookmarks";
        "type" = "folder";
        "children" = [ ];
      };
      "synced" = {
        "name" = "Mobile Bookmarks";
        "type" = "folder";
        "children" = [ ];
      };
    };
  };
}
