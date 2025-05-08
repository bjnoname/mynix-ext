{ pkgs, ... }:

let
  fd = "${pkgs.fd}/bin/fd";
  bat = "${pkgs.bat}/bin/bat";
  xsel = "${pkgs.xsel}/bin/xsel";
in
{
  programs.fzf = {

    enable = true;

    enableBashIntegration = true;

    defaultOptions = [
      "--border='rounded'"
      "--preview-window='border-rounded'"
      "--separator='─'"
      "--scrollbar='│'"
      "--info='right'"
      "--marker='+'"
      "--pointer='>'"
    ];

    fileWidgetCommand = "${fd} --type f";
    fileWidgetOptions = [
      "--height 60%"
      "--preview '${bat} -n --color=always {}'"
      "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
      "--bind 'alt-up:preview-page-up,alt-down:preview-page-down'"
    ];

    historyWidgetOptions = [
      "--preview 'echo {}' --preview-window up:3:hidden:wrap"
      "--bind 'ctrl-/:toggle-preview'"
      "--bind 'ctrl-y:execute-silent(echo -n {2..} | ${xsel} -p)+abort'"
      "--color header:italic"
      "--header 'Press CTRL-Y to copy command into clipboard'"
    ];
  };
}
