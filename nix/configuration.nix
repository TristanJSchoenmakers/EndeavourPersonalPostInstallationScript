# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

let
  secrets = if builtins.pathExists ./secrets.nix
              then import ./secrets.nix
            else {};
  environmentConfig = if secrets.environment == "work"
                        then import ./work.nix
                      else if secrets.environment == "home"
                        then import ./home.nix
                      else {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      environmentConfig
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  powerManagement.enable = false;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true; # Enable networking

  # Set your time zone & internationalisation
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 3d";
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    excludePackages = [ pkgs.xterm ];
    xkb.variant = "";
    xkb.layout = "";
  };

  documentation.nixos.enable = false;
  programs.geary.enable = false;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-connections
    gnome-console
    gnome-text-editor
  ]) ++ (with pkgs.gnome; [
    cheese      # photo booth
    eog         # image viewer
    epiphany    # web browser
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    evince      # document viewer
    seahorse    # password manager
    gnome-terminal gnome-logs gnome-characters gnome-clocks gnome-contacts
    gnome-font-viewer gnome-calculator gnome-maps gnome-music gnome-weather 
  ]);

  environment.sessionVariables.MYENV = secrets.environment;
  programs.hyprlock.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Enable gnome RDP
  # services.gnome.gnome-remote-desktop.enable = true;
  # networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedTCPPorts = [ 22 80 443 5900 ];

  virtualisation.docker = {
    enable = true;
    daemon.settings.data-root = "/nix/persist/docker";
  };
  programs.starship.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johndoe = {
    isNormalUser = true;
    description = "johndoe";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-7.0.410"
    "dotnet-sdk-wrapped-7.0.410"
  ];

  environment.systemPackages = with pkgs; [
    # system
    # home-manager
    # display
    hyprpaper
    # hyprcursor
    hyprshot
      libnotify
      wl-clipboard
    wofi
    waybar
    overskride
    wayvnc
    fira-code
    fira-code-nerdfont
    noto-fonts
    # terminal, CLI & TUI's
    alacritty
    yazi
    bat
    glow
    git
    pinentry-curses
    cloudflared
    gitui
    gh
    lazydocker
    drill
    kubectl
    doctl
    lens
    # Programming language build tools
    rustup
    gcc
    # (with dotnetCorePackages; combinePackages [
    #   sdk_8_0
    #   sdk_9_0
    # ])
    dotnet-sdk_8
    dotnet-aspnetcore_8
    nodejs_20
    # IDE & LSP's
    helix
    jetbrains.rider
    vscode-langservers-extracted
    clang-tools
    nil
    markdown-oxide
    # applications
    brave
    remmina
    keepassxc
    mpv-unwrapped
    zathura
    slack
  ];

  environment.etc."hosts".text = lib.mkForce ''
    127.0.0.1 localhost
    127.0.0.1       youtube.com
    127.0.0.1       www.youtube.com
    127.0.0.1       9gag.com
    127.0.0.1       www.9gag.com
    
    127.0.0.1       x.com
    127.0.0.1       www.x.com
    127.0.0.1       twitter.com
    127.0.0.1       www.twitter.com
    127.0.0.1       trends24.in
    127.0.0.1       www.trends24.in
    
    127.0.0.1       ad.nl
    127.0.0.1       www.ad.nl
    127.0.0.1       nrc.nl
    127.0.0.1       www.nrc.nl
    127.0.0.1       nu.nl
    127.0.0.1       www.nu.nl
    127.0.0.1       nos.nl
    127.0.0.1       www.nos.nl
    127.0.0.1       telegraaf.nl
    127.0.0.1       www.telegraaf.nl
    127.0.0.1       trouw.nl
    127.0.0.1       www.trouw.nl
    127.0.0.1       volkskrant.nl
    127.0.0.1       www.volkskrant.nl
    127.0.0.1       peilingennederland.nl
    127.0.0.1       www.peilingennederland.nl
    
    127.0.0.1       theguardian.com
    127.0.0.1       www.theguardian.com
    127.0.0.1       cnn.com
    127.0.0.1       www.cnn.com
    127.0.0.1       edition.cnn.com
    127.0.0.1       www.edition.cnn.com
    127.0.0.1       foxnews.com
    127.0.0.1       www.foxnews.com
    127.0.0.1       msnbc.com
    127.0.0.1       www.msnbc.com
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
