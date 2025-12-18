#!/bin/bash

# Dataset: https://www.modelscope.cn/datasets/inclusionAI/SPEECHFAKE/files

source ./download/config.sh

DEST="$ROOT/speechfake"
RAW_DIR="$DEST/raw/speechfake"
mkdir -p "$DEST/raw"
mkdir -p "$DEST/processed"

if [ ! -d "$RAW_DIR" ] || [ -z "$(ls -A "$RAW_DIR" 2>/dev/null)" ]; then
    echo "Error: Raw directory is empty or does not exist: $RAW_DIR"
    echo ""
    echo "Please download the dataset first using modelscope CLI:"
    echo "  modelscope download --dataset inclusionAI/SPEECHFAKE --local_dir $RAW_DIR"
    echo ""
    echo "Make sure you have modelscope installed:"
    echo "  pip install -U modelscope"
    exit 1
fi

echo "Processing SpeechFake dataset from $RAW_DIR..."

echo "Extracting SpeechFake dataset files..."

for tar_file in "$RAW_DIR"/*.tar.gz; do
    if [ -f "$tar_file" ]; then
        echo "Extracting $(basename $tar_file)..."
        tar -xzf "$tar_file" -C "$DEST/processed"
    fi
done

for zip_file in "$RAW_DIR"/*.zip; do
    if [ -f "$zip_file" ]; then
        echo "Extracting $(basename $zip_file)..."
        7z x "$zip_file" -o"$DEST/processed" -y
    fi
done

for sevenz_file in "$RAW_DIR"/*.7z; do
    if [ -f "$sevenz_file" ]; then
        echo "Extracting $(basename $sevenz_file)..."
        7z x "$sevenz_file" -o"$DEST/processed" -y
    fi
done

if [ -z "$(find "$DEST/processed" -type f 2>/dev/null)" ]; then
    echo "No archive files found. Checking if files are already extracted..."
    if [ -d "$RAW_DIR" ] && [ -n "$(find "$RAW_DIR" -type f \( -name "*.wav" -o -name "*.flac" -o -name "*.mp3" -o -name "*.txt" -o -name "*.json" \) 2>/dev/null)" ]; then
        echo "Copying audio and metadata files to processed directory..."
        cp -r "$RAW_DIR"/* "$DEST/processed/" 2>/dev/null || true
    fi
fi

echo " --- SpeechFake dataset download and extraction complete. Files saved in $DEST --- "
