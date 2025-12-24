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

mkdir -p "$DEST/processed/BD"
mkdir -p "$DEST/processed/MD"
mkdir -p "$DEST/processed/Real"
mkdir -p "$DEST/processed/metadata"

echo "Extracting SpeechFake dataset files..."

if [ -f "$RAW_DIR/BD/BD.zip" ]; then
    echo "Extracting BD/ split ZIP archive (this may take a while)..."
    7z x "$RAW_DIR/BD/BD.zip" -o"$DEST/processed/BD" -y >/dev/null 2>&1
    # In case of BD/BD/, move BD/BD.zip to BD/
    if [ -d "$DEST/processed/BD/BD" ]; then
        mv "$DEST/processed/BD/BD"/* "$DEST/processed/BD/" 2>/dev/null || true
        rmdir "$DEST/processed/BD/BD" 2>/dev/null || true
    fi
    echo "BD/ extraction complete."
else
    echo "Warning: BD/BD.zip not found, skipping BD extraction."
fi

if [ -f "$RAW_DIR/MD/MD.zip" ]; then
    echo "Extracting MD/ split ZIP archive (this may take a while)..."
    7z x "$RAW_DIR/MD/MD.zip" -o"$DEST/processed/MD" -y >/dev/null 2>&1
    if [ -d "$DEST/processed/MD/MD" ]; then
        mv "$DEST/processed/MD/MD"/* "$DEST/processed/MD/" 2>/dev/null || true
        rmdir "$DEST/processed/MD/MD" 2>/dev/null || true
    fi
    echo "MD/ extraction complete."
else
    echo "Warning: MD/MD.zip not found, skipping MD extraction."
fi

if [ -d "$RAW_DIR/Real" ]; then
    echo "Extracting Real/ dataset ZIP files..."
    for zip_file in "$RAW_DIR/Real"/*.zip; do
        if [ -f "$zip_file" ]; then
            zip_name=$(basename "$zip_file" .zip)
            echo "Extracting $(basename $zip_file) to Real/$zip_name/..."
            7z x "$zip_file" -o"$DEST/processed/Real/$zip_name" -y >/dev/null 2>&1
            # Move contents up one level if extracted with directory prefix matching zip name
            if [ -d "$DEST/processed/Real/$zip_name/$zip_name" ]; then
                mv "$DEST/processed/Real/$zip_name/$zip_name"/* "$DEST/processed/Real/$zip_name/" 2>/dev/null || true
                rmdir "$DEST/processed/Real/$zip_name/$zip_name" 2>/dev/null || true
            fi
        fi
    done
    echo "Real/ extraction complete."
else
    echo "Warning: Real/ directory not found, skipping Real extraction."
fi

if [ -f "$RAW_DIR/metadata/metadata.zip" ]; then
    echo "Extracting metadata.zip..."
    7z x "$RAW_DIR/metadata/metadata.zip" -o"$DEST/processed/metadata" -y >/dev/null 2>&1
    if [ -d "$DEST/processed/metadata/metadata" ]; then
        mv "$DEST/processed/metadata/metadata"/* "$DEST/processed/metadata/" 2>/dev/null || true
        rmdir "$DEST/processed/metadata/metadata" 2>/dev/null || true
    fi
    echo "Metadata extraction complete."
else
    echo "Warning: metadata/metadata.zip not found, skipping metadata extraction."
fi

# Final file structure:
# BD/
#  └── attacker 
# MD/
#  └── attacker 
# Real/
#  └── src 
# metadata/

echo " --- SpeechFake dataset download and extraction complete. Files saved in $DEST --- "
