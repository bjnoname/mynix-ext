{
  wsl = {
    enable = true;
    defaultUser = "jordy";
    useWindowsDriver = true;
    wslConf.network.generateResolvConf = false;
  };

  networking.hostName = "nixos-wsl"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/London";

  virtualisation.docker.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.11"; # Did you read the comment?
}
