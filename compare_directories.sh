#!/bin/bash
# This script compares the file lists of two directories.

# Check if two directories are provided as arguments.
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <dir1> <dir2>"
  exit 1
fi

# Store the directory names in variables.
dir1="$1"
dir2="$2"

# Check if the directories exist.
if [ ! -d "$dir1" ]; then
  echo "Error: Directory '$dir1' not found."
  exit 1
fi
if [ ! -d "$dir2" ]; then
  echo "Error: Directory '$dir2' not found."
  exit 1
fi

# Get the list of files in each directory.  Use find to handle subdirectories
files1=($(find "$dir1" -type f -print0 | sort -z | tr '\0' '\n'))
files2=($(find "$dir2" -type f -print0 | sort -z | tr '\0' '\n'))

# Use 'comm' to find the differences.
echo "Files only in $dir1:"
comm -23 <(printf '%s\n' "${files1[@]}") <(printf '%s\n' "${files2[@]}")

echo "Files only in $dir2:"
comm -13 <(printf '%s\n' "${files1[@]}") <(printf '%s\n' "${files2[@]}")

echo "Files present in both $dir1 and $dir2:"
comm -12 <(printf '%s\n' "${files1[@]}") <(printf '%s\n' "${files2[@]}")
