#!/bin/bash

set -e

echo "Make application backup..."

BACKUPS_ROOT=backups/$(date '+%d-%m-%Y')

if [[ ! -d $BACKUPS_ROOT ]];
then
	echo "Creating backup directory..."
	mkdir -p "$BACKUPS_ROOT"
fi

# TODO: make database dump

touch dump.sql

gzip --best dump.sql

mv dump.sql.gz "$BACKUPS_ROOT"

zip -9 -qj uploads.zip backend/web/uploads/*
mv uploads.zip "$BACKUPS_ROOT"

echo "Backup is ready!"
