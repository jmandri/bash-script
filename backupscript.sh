#!/bin/bash

# Check if two arguments are provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 source_directory target_directory"
  exit 1
fi

# Get current date and time for backup directory name
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Check if target is remote or local
if [[ $2 == *"@"* ]]; then
  # Copy to remote target using rsync over ssh
  ssh -o "StrictHostKeyChecking=no" $2 "mkdir -p backups"
  rsync -az --delete --link-dest="$2/current" "$1" "$2:backups/$timestamp"
else
  # Copy to local target using rsync
  mkdir -p "$2/backups"
  rsync -az --delete --link-dest="$2/current" "$1" "$2/backups/$timestamp"
fi

# Create symlink to latest backup
if [ -e "$2/current" ]; then
  rm "$2/current"
fi
ln -s "$2/backups/$timestamp" "$2/current"

if [ $? -ne 0 ]; then
  echo "Failed to create symlink to latest backup."
  exit 1
fi

echo "Backup completed successfully."
exit 0
