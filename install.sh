#!/bin/bash

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  rsync --exclude ".git/" --exclude ".install.sh" --exclude "Makefile" --exclude "README.md" -av . ~/.
else
  echo "Ok, maybe next time"
fi
