#!/bin/bash

set -e

BACKUP_DIR=backups/$1
RESTORE_DIR=backend/web/uploads
RESTORE_DATE=$1
CURRENT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"


if [[ ! $RESTORE_DATE ]]
then
   echo "ERROR: date not entered"
   exit 1
fi

if [[ ! $RESTORE_DATE =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]
then
   echo "ERROR: invalid date format!"
   echo "Correct formmat is dd-mm-YYYY"
   exit 1
fi


if [[ ! -d $BACKUP_DIR ]]
then
   echo "ERROR: no backup was found for the entered date"
   exit 1
fi

if [[ ! -f "$BACKUP_DIR/uploads.zip" ]]
then
   echo "ERROR: backup archive is missing"
   exit 1
elif [[ ! -f "$BACKUP_DIR/dump.sql.gz" ]]
then
   echo "ERROR: SQL dump is missing"
   exit 1
fi

if [[ ! -d $RESTORE_DIR ]]
then
   echo "The restore directory ($RESTORE_DIR) does not exist -> will be created."
   mkdir -p "$RESTORE_DIR"
else
   rm -rf $RESTORE_DIR/*
fi

unzip -q $BACKUP_DIR/uploads.zip -d $RESTORE_DIR/
gzip -dc $BACKUP_DIR/dump.sql.gz > $CURRENT_DIR/dump.sql

echo "Restore completed successfully"