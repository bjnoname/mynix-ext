{ config, pkgs, ... }:
let
  cfg = config.xsession.windowManager.i3;

  fonts = {
    names = [ "-misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1" ];
    size = 11.0;
  };

  maim = "${pkgs.maim}/bin/maim";
  xclip = "${pkgs.xclip}/bin/xclip";
in
{
  programs.i3status-rust = {
    enable = true;
    bars.status = {
      icons = "material-nf";
      theme = "srcery";
      blocks =
        [
          {
            block = "external_ip";
          }
          {
            block = "net";
            device = "wlan*";
            format = " {$icon $signal_strength} ";
            format_alt = " {$icon $signal_strength $ssid} ";
          }
          {
            block = "cpu";
          }
          {
            alert = 10.0;
            block = "disk_space";
            format = " $icon $available.eng(w:2) ";
            info_type = "available";
            interval = 20;
            path = "/";
            warning = 20.0;
          }
          {
            block = "memory";
            format = " $icon $mem_total_used_percents.eng(w:2) ";
            format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
          }
          {
            block = "temperature";
            format = " $icon ";
            format_alt = " $icon {$average avg, $max max |}";
          }
          {
            block = "battery";
          }
          {
            block = "sound";
            max_vol = 300;
            format = " $icon {$volume.eng(w:2) |}";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m %R') ";
            interval = 5;
          }
        ];
    };
  };

  xsession.windowManager.i3 = {

    enable = true;

    config = {

      modifier = "Mod4";

      inherit fonts;

      window = {
        titlebar = false;
        border = 0;
      };

      gaps = {
        inner = 5;
        smartGaps = true;
      };

      bars = [
        {
          mode = "dock";
          hiddenState = "hide";
          position = "bottom";
          workspaceButtons = true;
          workspaceNumbers = true;
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-status.toml";
          inherit fonts;
          trayOutput = "primary";
          colors = {
            background = "#000000";
            statusline = "#ffffff";
            separator = "#666666";
            focusedWorkspace = {
              border = "#4c7899";
              background = "#285577";
              text = "#ffffff";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
            };
            urgentWorkspace = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
          };
        }
      ];

      keybindings = {
        "${cfg.config.modifier}+Return" = "exec ${cfg.config.terminal}";
        "${cfg.config.modifier}+Shift+q" = "kill";
        "${cfg.config.modifier}+d" = "exec ${cfg.config.menu}";

        # Arrow style focus commands
        "${cfg.config.modifier}+Left" = "focus left";
        "${cfg.config.modifier}+Down" = "focus down";
        "${cfg.config.modifier}+Up" = "focus up";
        "${cfg.config.modifier}+Right" = "focus right";

        # Vim style focus commands
        "${cfg.config.modifier}+Ctrl+h" = "focus left";
        "${cfg.config.modifier}+Ctrl+j" = "focus down";
        "${cfg.config.modifier}+Ctrl+k" = "focus up";
        "${cfg.config.modifier}+Ctrl+l" = "focus right";

        # Arrow style move commands
        "${cfg.config.modifier}+Shift+Left" = "move left";
        "${cfg.config.modifier}+Shift+Down" = "move down";
        "${cfg.config.modifier}+Shift+Up" = "move up";
        "${cfg.config.modifier}+Shift+Right" = "move right";

        # Arrow style move commands
        "${cfg.config.modifier}+Shift+h" = "move left";
        "${cfg.config.modifier}+Shift+j" = "move down";
        "${cfg.config.modifier}+Shift+k" = "move up";
        "${cfg.config.modifier}+Shift+l" = "move right";

        "${cfg.config.modifier}+g" = "split h";
        "${cfg.config.modifier}+v" = "split v";
        "${cfg.config.modifier}+f" = "fullscreen toggle";

        "${cfg.config.modifier}+s" = "layout stacking";
        "${cfg.config.modifier}+w" = "layout tabbed";
        "${cfg.config.modifier}+e" = "layout toggle split";

        "${cfg.config.modifier}+Shift+space" = "floating toggle";
        "${cfg.config.modifier}+space" = "focus mode_toggle";

        "${cfg.config.modifier}+a" = "focus parent";

        "${cfg.config.modifier}+Shift+minus" = "move scratchpad";
        "${cfg.config.modifier}+minus" = "scratchpad show";

        "${cfg.config.modifier}+1" = "workspace number 1";
        "${cfg.config.modifier}+2" = "workspace number 2";
        "${cfg.config.modifier}+3" = "workspace number 3";
        "${cfg.config.modifier}+4" = "workspace number 4";
        "${cfg.config.modifier}+5" = "workspace number 5";
        "${cfg.config.modifier}+6" = "workspace number 6";
        "${cfg.config.modifier}+7" = "workspace number 7";
        "${cfg.config.modifier}+8" = "workspace number 8";
        "${cfg.config.modifier}+9" = "workspace number 9";
        "${cfg.config.modifier}+0" = "workspace number 10";

        "${cfg.config.modifier}+Shift+1" =
          "move container to workspace number 1";
        "${cfg.config.modifier}+Shift+2" =
          "move container to workspace number 2";
        "${cfg.config.modifier}+Shift+3" =
          "move container to workspace number 3";
        "${cfg.config.modifier}+Shift+4" =
          "move container to workspace number 4";
        "${cfg.config.modifier}+Shift+5" =
          "move container to workspace number 5";
        "${cfg.config.modifier}+Shift+6" =
          "move container to workspace number 6";
        "${cfg.config.modifier}+Shift+7" =
          "move container to workspace number 7";
        "${cfg.config.modifier}+Shift+8" =
          "move container to workspace number 8";
        "${cfg.config.modifier}+Shift+9" =
          "move container to workspace number 9";
        "${cfg.config.modifier}+Shift+0" =
          "move container to workspace number 10";

        "${cfg.config.modifier}+Shift+c" = "reload";
        "${cfg.config.modifier}+Shift+r" = "restart";
        "${cfg.config.modifier}+Shift+e" =
          "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${cfg.config.modifier}+r" = "mode resize";
      };

      menu = "${pkgs.dmenu}/bin/dmenu_run -fn 'xft:DejaVuSansMNerdFontMono:pixelsize=18:antialias=true:hinting=true'";

      defaultWorkspace = "workspace number 1";
    };


    extraConfig = ''

            set $wallpaper ~/.config/i3/Linux-Wallpaper-32.png

            exec_always --no-startup-id feh --bg-fill $wallpaper

            bindsym ${cfg.config.modifier}+q exec i3lock -f -i $wallpaper

            ## Clipboard Screenshots
            bindsym Ctrl+Print exec --no-startup-id ${maim} -f png | ${xclip} -selection clipboard -t image/png
            bindsym Ctrl+${cfg.config.modifier}+Print exec --no-startup-id ${maim} -f png --select | ${xclip} -selection clipboard -t image/png

        '';
  };

  home.file.".config/i3/Linux-Wallpaper-32.png".source = ./Linux-Wallpaper-32.png;

  home.file."startwm.sh" = {
    executable = true;
    source = pkgs.writeText "startvm.sh" ''
                 #!/usr/bin/env ${pkgs.bash}

                 . /etc/profile

                 [ -f $HOME/.profile ] || [ -L $HOME/.profile ] && . $HOME/.profile

                 ${pkgs.xorg.xrdb}/bin/xrdb ~/.Xresources

                 ${pkgs.i3}/bin/i3;
      	'';
  };
}
