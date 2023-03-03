# GNU Guix System configuration
> All of the following intiial setup information is from memory so here be dragons, future me (or you random daredevil looking at this) be aware.

## Filesystem
This configuration expects a BTRFS filesystem (what else?) on one partition for primary storage and swap, identified by a `GUIX` label. And one vfat partition for the bootloader and kernel which is identified by it's partition ID. 

### BTRFS
The subvolumes which are expected to exist on the root of the disk.
- `/subvolume/root`
- `/subvolume/home`
- `/subvolume/swap`
  - Disable Copy on Write using `chattr`
  - Create a swapfile named `swapfile` inside subvolume
- `/snapshots/root`
- `/snapshots/home`

## Rest of the configuration
Follow the official [Manual installation guide](https://guix.gnu.org/manual/en/html_node/Manual-Installation.html)

## LICENSE
[MIT](LICENSE)
