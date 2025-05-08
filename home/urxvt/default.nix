{ ... }:

{
  programs.urxvt = {

    enable = true;

    scroll = {
      bar.enable = false;
      lines = 65535;
    };

    transparent = true;

    shading = 20;

    fonts = [ "xft:DejaVuSansMNerdFontMono:pixelsize=18:antialias=true:hinting=true" ];

    keybindings = {
      "C-Down" = "resize-font:smaller";
      "C-Up" = "resize-font:bigger";
      "M-c" = "perl:clipboard:copy";
      "M-v" = "perl:clipboard:paste";
    };

    extraConfig = {
      background = "#1F1D19";
      foreground = "#DEDEDE";
      geometry = "400x400";
      "clipboard.autocopy" = "true";
      perl-ext-common = "-confirm-paste,clipboard,selection-to-clipboard,resize-font";
    };
  };
}
