#!/bin/bash


source ./download/config.sh

DEST="$ROOT/sonics"
RAW_DIR="$DEST/raw/sonics"
mkdir -p "$DEST/raw"
mkdir -p "$DEST/processed"

if [ ! -d "$RAW_DIR" ] || [ -z "$(ls -A "$RAW_DIR" 2>/dev/null)" ]; then
    echo "Error: Raw directory is empty or does not exist: $RAW_DIR"
    echo ""
    echo "Please download the dataset first using huggingface-cli:"
    echo "  huggingface-cli download awsaf49/sonics --repo-type dataset --local-dir $RAW_DIR"
    echo ""
    echo "Make sure you are logged in:"
    echo "  huggingface-cli login"
    exit 1
fi

echo "Processing sonics dataset from $RAW_DIR..."

FAKE_SONGS_DIR="$RAW_DIR/fake_songs"
if [ ! -d "$FAKE_SONGS_DIR" ]; then
    echo "Error: fake_songs directory not found: $FAKE_SONGS_DIR"
    exit 1
fi

echo "Extracting sonics dataset parts..."
for zip_file in "$FAKE_SONGS_DIR"/*.zip; do
    if [ -f "$zip_file" ]; then
        echo "Extracting $(basename $zip_file)..."
        7z x "$zip_file" -o"$DEST/processed" -y
    fi
done

echo " --- sonics dataset download and extraction complete. Files saved in $DEST --- "