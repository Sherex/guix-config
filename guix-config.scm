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
  bash)

(operating-system
  (host-name "guixtop")
  (timezone "Europe/Oslo")
  (locale "en_US.utf8")

  (keyboard-layout (keyboard-layout "no" "latin1"))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (target "/boot/efi")
                (keyboard-layout keyboard-layout)))
                ;;(menu-entries
                ;;  (menu-entry
                ;;    (label "LapArchy")
                ;;    (linux "/boot/vmlinuxXXX")
                ;;    (linux-arguments '("root=/dev/sda1"))
                ;;    (initrd "/boot/initrd")))

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

  (swap-devices `("/swap/swapfile"))

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
                     swaylock
		     ;; Misc
		     bash-completion
                     ;; User packages (use Guix Home later, but one step at the time..)
                     git
                     neovim
                     qutebrowser
                     rofi
                     kitty
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
