#!/bin/bash

#
# Script Name: compare_files.sh
# Purpose: This script can be used to compare the contents of same files in 2 different directories using the sha256sum.
#
# Author: Prasanth Soman
# Date: 19-Apr-2024
# Version: 1.0
#

# How to use the script:
# - Run the script with directory arguments:
#	./checksum_compare_args.sh /path/to/source/directory /path/to/destination/directory
#
#	Replace /path/to/source/directory and /path/to/destination/directory with the actual paths to your directories.
#
# - Example:
#	If your source directory is /tmp/original_files and your destination directory is /opt/deployed_files, you would run the script like this:
#
#	./checksum_compare_args.sh /tmp/original_files /opt/deployed_files
#


# Check if the correct number of arguments is provided
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source_directory> <destination_directory>"
  exit 1
fi

SOURCE_DIR="$1"
DESTINATION_DIR="$2"

# Check if the source directory exists
if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: Source directory '$SOURCE_DIR' does not exist."
  exit 1
fi

# Check if the destination directory exists
if [[ ! -d "$DESTINATION_DIR" ]]; then
  echo "Error: Destination directory '$DESTINATION_DIR' does not exist."
  exit 1
fi

# Find files with the same name in both directories
for file in $(find "$SOURCE_DIR" -type f -printf "%f\n"); do
  source_file="$SOURCE_DIR/$file"
  destination_file="$DESTINATION_DIR/$file"

  if [[ -f "$destination_file" ]]; then
    source_checksum=$(sha256sum "$source_file" | awk '{print $1}')
    destination_checksum=$(sha256sum "$destination_file" | awk '{print $1}')

    if [[ "$source_checksum" != "$destination_checksum" ]]; then
      echo "Checksum mismatch for file: $file"
      echo "  Source:      $source_checksum"
      echo "  Destination: $destination_checksum"
    fi
  fi
done

echo "Checksum comparison complete."

exit 0