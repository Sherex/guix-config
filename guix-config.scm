(use-modules (gnu) (gnu system nss))

(use-service-modules
  desktop
  networking
  pm)

(use-package-modules 
  certs
  vim
  version-control
  wm
  web-browsers
  xdisorg
  terminals
  freedesktop
  rust-apps
  linux
  gnome
  fonts
  fontutils
  bash
  video
  image
  admin
  xorg
  qt)

(operating-system
  (host-name "guixtop")
  (timezone "Europe/Oslo")
  (locale "en_US.utf8")

  (keyboard-layout (keyboard-layout "no" "latin1"))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)
                (menu-entries (list
                  (menu-entry ;; BUG: kernel and initram images paths are prefixed with BTRFS subvolume
                              ;; (but they are located on another partition)
                    (label "LapArchy")
                    (device (uuid "4C39-6E71" 'fat))
                    (device-mount-point "/boot")
                    (linux "/boot/vmlinuz-linux")
                    (linux-arguments '("root=/dev/sda2" "rw" "rootflags=subvol=subvolumes/root"))
                    (initrd "/boot/intel-ucode.img /boot/initramfs-linux.img"))))))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "GUIX"))
                         (mount-point "/")
                         (type "btrfs")
                         (options "subvol=/subvolumes/root"))
                       (file-system
                         (device (file-system-label "GUIX"))
                         (mount-point "/swap")
                         (type "btrfs")
                         (options "subvol=/subvolumes/swap"))
                       (file-system
                         (device (uuid "01A8-011B" 'fat))
                         (mount-point "/boot/efi")
                         (type "vfat")))
                 %base-file-systems))

  (swap-devices (list (swap-space (target "/swap/swapfile"))))

  (users (cons (user-account
                (name "sherex")
                (password "")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video")))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
                     ;; for HTTPS access
                     nss-certs
                     ;; Power management
                     upower
                     tlp
                     tp-smapi-module ;; Thinkpad specific
                     ;; Sway
                     sway
                     swaybg
                     swaylock-effects
                     swayidle
                     ;; Wayland
                     xdg-desktop-portal-wlr ;; Screensharing and more
                     mako
                     gammastep
                     wl-clipboard
                     egl-wayland
                     ;; Misc
                     bash-completion
                     ;; User packages (use Guix Home later, but one step at the time..)
                     git
                     neovim
                     qutebrowser
                     rofi
                     kitty
                     wf-recorder
                     swappy
                     grim
                     slurp
                     bat
                     fd
                     htop
                     btop
                     ;; Fonts
                     font-gnu-freefont
                     font-gnu-unifont
                     ;;font-google-noto
                     ;;font-liberation
                     ;;font-adobe-source-sans-pro
                     font-hack
                     font-awesome
                     ;; Fontconfig
                     fontconfig
                     ;; Sway user specific
                     i3status-rust)
             %base-packages))

  (services (append (list
                     (service elogind-service-type)
                     (service dhcp-client-service-type)
                     (service upower-service-type)
                     (service tlp-service-type))
             %base-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
