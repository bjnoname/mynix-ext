{ config, ... }:

let
  bashrc_extra = config.home.homeDirectory + "/.bashrc_extra";
in
{
  programs.bash = {

    enable = true;

    initExtra = ''

        export LS_COLORS="$(vivid -m 8-bit generate snazzy)";

        set -o vi

        # Prompt
        parse_git_branch() {
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
        }

        ps_green='\[\e[0;32m\]'
        ps_purple='\[\e[0;35m\]'
        ps_cyan='\[\e[0;36m\]'
        ps_reset='\[\e[m\]'

        PS1="$ps_green[\W]$ps_purple\$(parse_git_branch) $ps_cyan$ $ps_reset";

        # Aliases
        source $(which complete_alias)
        complete -F _complete_alias "''${!BASH_ALIASES[@]}"

        source <(kubectl completion bash)
        alias k=kubecolor
        complete -o default -F __start_kubectl k

        [ -f "${bashrc_extra}" ] && source ${bashrc_extra}

    '';

    shellAliases = {
      cdr = "cd \${DEVENV_ROOT:-$HOME}";
      k = "kubecolor";
      awslocal = "aws --endpoint-url http://localhost:4566";
    };
  };
}
