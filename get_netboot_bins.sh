#!/usr/bin/env bash

validate_command () {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "$1 not found"
		exit 1
	fi
}

download_file () {
	echo "Downloading $1"
	wget -q -O "$2/$1" "https://github.com/netbootxyz/netboot.xyz/releases/latest/download/$1"
	if [ $? -ne 0 ]; then
		echo "Failed to download $1"
		return 1
	fi
	if [ ! -f "$2/$1" ]; then
		echo "Failed to write $1 to disk"
		return 1
	fi	
}

upsert_file () {
	if [ -f "$3/$1" ]; then
		echo "Existing $1 file found"
		EXISTINGSHA=$(sha256sum "$3/$1" | awk '{print $1}')
		NEWSHA=$(sha256sum "$2/$1" | awk '{print $1}')
	
		if [ "${EXISTINGSHA}" != "${NEWSHA}" ]; then
			echo "Overwriting $3/$1 with new version"
			cp "$2/$1" "$3/$1"
		else
			echo "No update needed for $1"
		fi
	else
		echo "Installing $1"
		cp "$2/$1" "$3/$1"
	fi
}

update_file () {
	TMPDIR=$(mktemp -d)
	
	download_file "$1" "${TMPDIR}"
	if [ $? -ne 0 ]; then
		rm -f "${TMPDIR}/$1"
		rmdir "${TMPDIR}"
		exit 1
	fi
	
	upsert_file "$1" "${TMPDIR}" "$2"
	
	rm -f "${TMPDIR}/$1"
	rmdir "${TMPDIR}"
}

validate_command "wget"
validate_command "sha256sum"

if [ $# -eq 0 ]; then
	echo "No destination directory argument received"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "Unable to find directory: $1"
	exit 1
fi

update_file "netboot.xyz-arm64.efi" "$1"
update_file "netboot.xyz.efi" "$1"
update_file "netboot.xyz.kpxe" "$1"

exit 0
