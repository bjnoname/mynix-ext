{ config, lib, ... }:
{

  sops = {
    secrets."xrdp/cert" = { key = "xrdp/cert"; };
    secrets."xrdp/key" = { key = "xrdp/key"; };
  };

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

  services.xrdp =
    let
      xrdp_cert = config.sops.secrets."xrdp/cert".path;
      xrdp_key = config.sops.secrets."xrdp/key".path;
    in
    {
      enable = true;
      extraConfDirCommands = ''

      mkdir -p $out

      rm -rf $out/*

      cp -r ${config.services.xrdp.package}/etc/xrdp/* $out
      chmod -R +w $out

      substituteInPlace $out/xrdp.ini \
        --replace-fail "port=3389" "port=tcp://:3388" \
        --replace-fail "certificate=" "certificate=${xrdp_cert}" \
        --replace-fail "key_file=" "key_file=${xrdp_key}" \
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

