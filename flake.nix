{
  description = "my overrides";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.my-overrides = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({config, ...}: {
          imports =
          [ # Include the results of the hardware scan.
            /etc/nixos/hardware-configuration.nix
          ];

          # Complete override: No import of /etc/nixos/configuration.nix

          # Bootloader.
          boot.loader.grub.enable = true;
          boot.loader.grub.device = "/dev/sda";
          boot.loader.grub.useOSProber = false;

          services.qemuGuest.enable = true;

          networking.hostName = "nixos"; # Define your hostname.
          # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

          # Configure network proxy if necessary
          # networking.proxy.default = "http://user:password@proxy:port/";
          # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

          # Enable networking
          networking.networkmanager.enable = true;

          # Set your time zone.
          time.timeZone = "America/Los_Angeles";

          # Select internationalisation properties.
          i18n.defaultLocale = "en_US.UTF-8";

          i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
          };

          # Enable the X11 windowing system.
          services.xserver.enable = true;

          # Enable the GNOME Desktop Environment.
          services.xserver.displayManager.gdm.enable = true;
          services.xserver.desktopManager.gnome.enable = true;

          # Configure keymap in X11
          services.xserver.xkb = {
            layout = "us";
            variant = "";
          };

          # Enable CUPS to print documents.
          services.printing.enable = true;

          # Enable sound with pipewire.
          # hardware.pulseaudio.enable = false;
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            # If you want to use JACK applications, uncomment this
            #jack.enable = true;

            # use the example session manager (no others are packaged yet so this is enabled by default,
            # no need to redefine it in your config for now)
            #media-session.enable = true;
          };

          # Enable touchpad support (enabled default in most desktopManager).
          # services.xserver.libinput.enable = true;


          # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
          systemd.services."getty@tty1".enable = false;
          systemd.services."autovt@tty1".enable = false;

          # Install firefox.
          programs.firefox.enable = true;

          # Allow unfree packages
          nixpkgs.config.allowUnfree = true;


          services.displayManager.autoLogin = {
            enable = true;
            user = "cloudgenius";
          };

          # Define a user account. Don't forget to set a password with ‘passwd’.
          users.users.cloudgenius = {
            isNormalUser = true;
            description = "Nilesh";
            extraGroups = [ "networkmanager" "wheel" ];
          };

          services.openssh.enable = true;
          services.openssh.settings.PasswordAuthentication = true;
          services.openssh.settings.PermitRootLogin = "yes";
          services.pulseaudio.enable = false;
          environment.systemPackages = with nixpkgs.legacyPackages.${system}; [
            htop
            git
            vim
            btop
            wget
          ];

          system.stateVersion = "24.11"; # Did you read the comment?
        })
      ];
    };
  };
}
