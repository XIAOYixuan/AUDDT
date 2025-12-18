#!/bin/bash

source ./download/config.sh

DEST="$ROOT/compspoof"
RAW_DIR="$DEST/raw/compspoof"
mkdir -p "$DEST/raw"
mkdir -p "$DEST/processed"

if [ ! -d "$RAW_DIR" ] || [ -z "$(ls -A "$RAW_DIR" 2>/dev/null)" ]; then
    echo "Error: Raw directory is empty or does not exist: $RAW_DIR"
    echo ""
    echo "Please download the dataset first using huggingface-cli:"
    echo "  huggingface-cli download XuepingZhang/CompSpoof --repo-type dataset --local-dir $RAW_DIR"
    echo ""
    echo "Make sure you are logged in:"
    echo "  huggingface-cli login"
    exit 1
fi

echo "Processing CompSpoof dataset from $RAW_DIR..."

TAR_FILE="$RAW_DIR/CompSpoof.tar.gz"
if [ ! -f "$TAR_FILE" ]; then
    echo "Error: CompSpoof.tar.gz not found: $TAR_FILE"
    exit 1
fi

echo "Extracting CompSpoof.tar.gz..."
tar -xzf "$TAR_FILE" -C "$DEST/processed"

METADATA_FILES=("CompSpoof_train.txt" "CompSpoof_dev.txt" "CompSpoof_eval.txt")
for metadata_file in "${METADATA_FILES[@]}"; do
    if [ ! -f "$RAW_DIR/$metadata_file" ]; then
        echo "Warning: Metadata file not found: $RAW_DIR/$metadata_file"
    else
        echo "Found metadata file: $metadata_file"
    fi
done

echo " --- CompSpoof dataset download and extraction complete. Files saved in $DEST --- "
