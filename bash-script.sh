#!/bin/bash

# Get current date and time for backup directory name
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Check if target is remote or local
if [[ $2 == *"@"* ]]; then
  # Copy to remote target using rsync over ssh
  rsync -az --delete --link-dest=$2/current $1 $2:backups/$timestamp
else
  # Copy to local target using rsync
  rsync -az --delete --link-dest=$2/current $1 $2/backups/$timestamp
fi

# Create symlink to latest backup
if [ -e "$2/current" ]; then
  rm $2/current
fi
ln -s $2/backups/$timestamp $2/current
