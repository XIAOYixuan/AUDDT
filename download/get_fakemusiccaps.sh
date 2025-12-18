#!/bin/bash

source ./download/config.sh

DEST="$ROOT/fakemusiccaps"
mkdir -p "$DEST/raw"
mkdir -p "$DEST/processed"

echo "Downloading FakeMusicCaps dataset..."
wget --no-check-certificate "https://zenodo.org/records/15063698/files/FakeMusicCaps.zip?download=1" -O "$DEST/raw/FakeMusicCaps.zip"

echo "Extracting FakeMusicCaps.zip..."
7z x "$DEST/raw/FakeMusicCaps.zip" -o"$DEST/processed" -y

echo " --- FakeMusicCaps dataset download and extraction complete. Files saved in $DEST --- "

