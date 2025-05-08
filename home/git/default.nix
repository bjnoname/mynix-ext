{ ... }:

{
  programs.git = {

    enable = true;

    userName = "jordy";
    userEmail = "jordy@nowhere.net";

    aliases = {
      ls = "log --oneline";
      diffn = "diff --name-only";
      resign = "rebase --exec 'git commit --amend --no-edit -n -S' -i";
    };
  };
}
