# netbootxyz-bin-updater
Shell script to update netboot.xyz boot binaries

# Purpose
This shell script downloads the PXE boot files for the [netboot.xyz](https://netboot.xyz) project.  It will grab files from the latest release on the [project GitHub page](https://github.com/netbootxyz/netboot.xyz).  Specifically, it downloads the `netboot.xyz-arm64.efi`, `netboot.xyz.efi`, and `netboot.xyz.kpxe` files.

The script relies on `wget` and `sha256sum` to handle downloads and checksumming.  If an existing file matches the same checksum, it won't be overwritten.

Note that this has the same risks as the main netboot.xyz project (reliance on an Internet connection and the safety of the hosted images) plus the integrity of the downloaded PXE boot files.

# Usage
`get_netboot_bins.sh /path/to/pxeboot/directory`
