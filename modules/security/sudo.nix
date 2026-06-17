_:

let
  blue = "[1;34m";
  red = "[1;31m";
  yellow = "[1;33m";
  reset = "[0m";
in {
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults pwfeedback
      Defaults passprompt = "${blue}>${yellow}>${red}>${reset} Password: "
    '';
  };
}
