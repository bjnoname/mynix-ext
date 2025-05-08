{ config, lib, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "jordy";
    useWindowsDriver = true;
  };

  networking.hostName = "nixos-wsl"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/London";

  virtualisation.docker.enable = true;

  networking.firewall.enable = false;

  services.xrdp = {
    enable = true;
    extraConfDirCommands = ''

      mkdir -p $out

      rm -rf $out/*

      cp -r ${config.services.xrdp.package}/etc/xrdp/* $out
      chmod -R +w $out

      substituteInPlace $out/xrdp.ini \
        --replace-fail "port=3389" "port=tcp://:3388" \
        --replace-fail "crypt_level=high" "crypt_level=none" \
        --replace-fail "security_layer=negotiate" "security_layer=rdp" \
        --replace-fail "bitmap_compression=true" "bitmap_compression=false"

      # Ensure that clipboard works for non-ASCII characters
      sed -i -e '/.*SessionVariables.*/ a\
      LANG=${config.i18n.defaultLocale}\
      LOCALE_ARCHIVE=${config.i18n.glibcLocales}/lib/locale/locale-archive
      ' $out/sesman.ini
    '';
  };

  systemd.services.xrdp = {

    serviceConfig = lib.mkForce (
      let
        cfg = config.services.xrdp;
      in
      {
        ExecStart = "${cfg.package}/bin/xrdp --nodaemon --config ${cfg.confDir}/xrdp.ini";
      }
    );
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
