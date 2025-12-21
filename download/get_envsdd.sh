#!/bin/bash

# Dataset: EnvSDD from Zenodo
# - EnvSDD-Development: 15220951
# - EnvSDD-Test: 15241138
# - EnvSDD-Remain: 15239720

source ./download/config.sh

DEST="$ROOT/envsdd"
RAW_DIR="$DEST/raw"
mkdir -p "$RAW_DIR"
mkdir -p "$DEST/processed"

# Check if zip files exist
ZIP_FILES=(
    "$RAW_DIR/development/development.zip"
    "$RAW_DIR/test/test.zip"
    "$RAW_DIR/remain/remain.zip"
)

MISSING_FILES=()
for zip_file in "${ZIP_FILES[@]}"; do
    if [ ! -f "$zip_file" ]; then
        MISSING_FILES+=("$zip_file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo "Error: Required zip files are missing:"
    for file in "${MISSING_FILES[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo "Please download the datasets first using zenodo_get:"
    echo "  pip install zenodo_get"
    echo "  zenodo_get 15220951 -o $RAW_DIR  # EnvSDD-Development (creates development/ subdirectory)"
    echo "  zenodo_get 15241138 -o $RAW_DIR  # EnvSDD-Test (creates test/ subdirectory)"
    echo "  zenodo_get 15239720 -o $RAW_DIR  # EnvSDD-Remain (creates remain/ subdirectory)"
    echo ""
    echo "Make sure you have zenodo_get installed:"
    echo "  pip install zenodo_get"
    exit 1
fi

echo "Processing EnvSDD dataset from $RAW_DIR..."

echo "Extracting EnvSDD dataset files..."

for zip_file in "${ZIP_FILES[@]}"; do
    if [ -f "$zip_file" ]; then
        echo "Extracting $(basename $zip_file)..."
        7z x "$zip_file" -o"$DEST/processed" -y
    fi
done

echo " --- EnvSDD dataset download and extraction complete. Files saved in $DEST --- "
