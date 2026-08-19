{ lib, pkgs, self, ... }:

let
  settingsJSON = builtins.toJSON {
    # Bread.
    "breadcrumbs.icons" = false;

    # Editor - behavioural
    "editor.accessibilitySupport" = "off";
    "editor.guides.bracketPairs" = true;
    "editor.wordWrap" = "on";

    # Editor - appearance
    "editor.cursorBlinking" = "smooth";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.fontFamily" = "'Google Sans Code', 'monospace'";
    "editor.fontLigatures" = true;
    "editor.minimap.enabled" = false;
    "editor.scrollbar.horizontal" = "hidden";
    "editor.smoothScrolling" = true;

    # Explorer
    "explorer.compactFolders" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "explorer.fileNesting.enabled" = true;
    "explorer.fileNesting.patterns"."flake.nix" = "flake.lock";

    # Files
    "files.autoSave" = "onWindowChange";
    "files.insertFinalNewline" = true;
    "files.trimTrailingWhitespace" = true;
    "files.watcherExclude"."**/.direnv/**" = true;

    # Search
    "search.exclude" = {
      "**/.direnv" = true;
      "**/result" = true;
      "**/result-*" = true;
    };

    # Terminal
    "terminal.integrated.fontFamily" = "'Google Sans Code', 'monospace'";
    "terminal.integrated.gpuAcceleration" = "on";
    "terminal.integrated.stickyScroll.enabled" = false;
    "terminal.integrated.shellIntegration.enabled" = false;
    "terminal.integrated.defaultProfile.linux" = "fish";
    "terminal.integrated.profiles.linux"."fish" = {
      "path" = "/run/current-system/sw/bin/fish";
      "args" = [ "-i" ];
    };

    # Window
    "window.commandCenter" = false;
    "window.dialogStyle" = "custom";
    "window.menuBarVisibility" = "hidden";
    "window.titleBarStyle" = "custom";

    # Workbench
    "workbench.colorTheme" = "Dark+";
    "workbench.editor.empty.hint" = "hidden";
    "workbench.editor.enablePreview" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.layoutControl.enabled" = false;
    "workbench.startupEditor" = "none";
    "workbench.tree.indent" = 16;
    "workbench.sideBar.location" = "right";
    "workbench.tree.renderIndentGuides" = "none";

    # Telemetry
    "telemetry.telemetryLevel" = "off";
    "extensions.autoCheckUpdates" = false;
    "extensions.autoUpdate" = "off";
    "update.mode" = "none";
    "update.showReleaseNotes" = false;

    # Extensions
    "direnv.restart.automatic" = true;
    "direnv.path.executable" = "${lib.getExe pkgs.direnv}";
    "errorLens.gutterIconsEnabled" = true;
    "errorLens.messageBackgroundMode" = "message";

    # Git
    "git.autofetch" = true;
    "git.confirmSync" = true;
    "diffEditor.ignoreTrimWhitespace" = false;

    # Language Server - Nix
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "${lib.getExe pkgs.nil}";
    "nix.serverSettings"."nil"."formatting"."command" = [ "${lib.getExe self.packages.${pkgs.stdenv.system}.alejandra-custom}" ];
    "nix.hiddenLanguageServerErrors" = [
      "textDocument/documentSymbol"
      "textDocument/formatting"
    ];

    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
      "editor.formatOnSave" = true;
    };

    # Language Server - C/C++
    "clangd.path" = "${lib.getExe' pkgs.clang-tools "clangd"}";
    "clangd.arguments" = [
      "--background-index"
      "--clang-tidy"
      "--header-insertion=never"
      "--compile-commands-dir=build"
    ];

    "[c]" = {
      "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "editor.formatOnSave" = true;
    };

    "[cpp]" = {
      "editor.defaultFormatter" = "llvm-vs-code-extensions.vscode-clangd";
      "editor.formatOnSave" = true;
    };

    # Language Server - Rust
    "rust-analyzer.check.command" = "clippy";
    "[rust]" = {
      "editor.defaultFormatter" = "rust-lang.rust-analyzer";
      "editor.formatOnSave" = true;
    };

    # Language Server - Meson
    "mesonbuild.buildFolder" = "build";
    "mesonbuild.linting.enabled" = true;
    "mesonbuild.muonPath" = "${pkgs.muon}/bin/muon";
    "mesonbuild.mesonPath" = "${pkgs.meson}/bin/meson";
    "[meson]"."editor.formatOnSave" = true;
  };

  keybindJSON = builtins.toJSON [
    {
      key = "ctrl+l";
      command = "workbench.action.terminal.clear";
      when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
    }
  ];

  argvJSON = builtins.toJSON {
    "enable-crash-reporter" = false;
    "crash-reporter-id" = "00000000-0000-0000-0000-000000000000";
    "password-store" = "gnome-libsecret";
  };
in {
  fonts.packages = [ pkgs.googlesans-code ];
  hjem.users.primaryUser.files = {
    ".vscode-oss/argv.json".text = argvJSON;
    ".config/VSCodium/User/settings.json".text = settingsJSON;
    ".config/VSCodium/User/keybindings.json".text = keybindJSON;
  };

  environment.systemPackages = with pkgs; [
    direnv
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with pkgs.vscode-extensions; [
        # Nix
        jnoortheen.nix-ide
        mkhl.direnv

        # C/C++
        llvm-vs-code-extensions.vscode-clangd

        # Rust
        rust-lang.rust-analyzer

        # Build systems
        mesonbuild.mesonbuild
        ms-vscode.cmake-tools

        # UI / UX
        pkief.material-icon-theme
        usernamehw.errorlens

        # Origin
        github.vscode-pull-request-github
      ];
    })
  ];
}
