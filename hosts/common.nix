{ config, pkgs, myusers, ... }:

{
  sops = {

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = ../secrets/common.enc.yaml;

    secrets."jordy/hashedPassword" = {
      neededForUsers = true;
    };
  };

  users = {

    mutableUsers = false;

    users.root = {
      openssh.authorizedKeys.keys = myusers.jordy.keys;
    };

    users.jordy = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "video" "audio" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [ wget git ];
      hashedPasswordFile = config.sops.secrets."jordy/hashedPassword".path;
      openssh.authorizedKeys.keys = myusers.jordy.keys;
    };
  };

  services.fail2ban = {
    enable = true;
    bantime = "1d";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jordy" ];
  };
}

