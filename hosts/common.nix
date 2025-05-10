{ config, pkgs, myusers, ... }:

{
  sops = {

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = ../secrets/common.enc.yaml;

    secrets."jordy/hashedPassword" = {
      neededForUsers = true;
    };

    secrets."localhost/key" = { key = "localhost/key"; };
  };

  security.pki.certificates =
    [
      (builtins.readFile ../certs/localhost.crt)
    ];

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

  systemd.services.localhost-cert =
    let
      openssl_cmd = "${pkgs.openssl}/bin/openssl";
      localhost_crt = ../certs/localhost.crt;
      localhost_key = config.sops.secrets."localhost/key".path;
      localhost_pfx = "/run/secrets/localhost/cert.pfx";
    in
    {
      description = "Export localhost certificate";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        mkdir -p $(dirname ${localhost_pfx})

        ${openssl_cmd} pkcs12 -in ${localhost_crt} -inkey ${localhost_key} -export -out ${localhost_pfx} -passout pass:

        chmod a+r ${localhost_pfx}
      '';
    };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "jordy" ];
  };
}

