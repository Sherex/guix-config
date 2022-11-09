(use-modules (gnu) (gnu system nss))
(use-service-modules desktop xorg)
(use-package-modules certs gnome vim version-control wm)

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
                     ;; for user mounts
                     gvfs
		     neovim
		     git
		     sway
		     swaybg
		     swaylock)
                    %base-packages))

  ;; Add GNOME and Xfce---we can choose at the log-in screen
  ;; by clicking the gear.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with
  ;; NetworkManager, and more.
  (services (append (list (service gnome-desktop-service-type)
                          (service xfce-desktop-service-type)
                          (set-xorg-configuration
                           (xorg-configuration
                            (keyboard-layout keyboard-layout))))
                    %desktop-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
