{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rofi ];
  hjem.users.primaryUser.files.".config/rofi/config.rasi".text = ''
    configuration { terminal: "foot"; }
      @theme "/dev/null"

      * {
        background-color: #000000;
        border-color: #FFFFFF;
        text-color: #FFFFFF;
        font: "monospace 10";
      }

      window {
        anchor: north;
        location: north;
        width: 100%;
        padding: 4px;
        children: [ horibox ];
      }

      horibox {
        orientation: horizontal;
        children: [ prompt, entry, listview ];
      }

      listview {
        layout: horizontal;
        spacing: 5px;
        lines: 100;
      }

      entry {
        expand: false;
        width: 10em;
      }

      prompt { margin: 0px 10px 0px 0px; }
      element { padding: 0px 2px; }
      element selected { background-color: #285577; }
      element-text, element-icon {
        background-color: inherit;
        text-color: inherit;
      }
  '';
}
