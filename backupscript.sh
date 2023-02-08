#!/bin/bash

# Get current date and time for backup directory
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Check if target is remote or local
if [[ $2 == *"@"* ]]; then
  # Copy to remote target using rsync over ssh
  ssh "$2" "mkdir -p backups"
  rsync -az --delete --link-dest=$2/current $1 $2:backups/$timestamp
else
  # Copy to local target using rsync
  mkdir -p $2/backups
  rsync -az --delete --link-dest=$2/current $1 $2/backups/$timestamp
fi

# Create symlink to latest backup
if [ -e "$2/current" ]; then
  rm $2/current
fi
ln -s $2/backups/$timestamp $2/current
