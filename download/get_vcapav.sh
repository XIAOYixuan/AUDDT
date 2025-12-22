#!/bin/bash

# Download the VCapAV dataset from HuggingFace
# Dataset: https://huggingface.co/datasets/WailyWang/VCapAV
# Only audio-related files are extracted.
# The dataset is split into the following directories:
# - T2A
# - V2A
# - VGGsound_test_14923_audio_cut

source ./download/config.sh

DEST="$ROOT/vcapav"
RAW_DIR="$DEST/raw"
PROCESSED_DIR="$DEST/processed"
mkdir -p "$RAW_DIR"
mkdir -p "$PROCESSED_DIR"

if [ ! -d "$RAW_DIR" ] || [ -z "$(ls -A "$RAW_DIR" 2>/dev/null)" ]; then
    echo "Error: Raw directory is empty or does not exist: $RAW_DIR"
    echo ""
    echo "Please download the dataset first using huggingface-cli:"
    echo "  huggingface-cli download WailyWang/VCapAV --repo-type dataset --local-dir $RAW_DIR"
    echo ""
    echo "Make sure you are logged in:"
    echo "  huggingface-cli login"
    exit 1
fi

echo "Extracting VCapAV dataset..."

T2A_DIR="$RAW_DIR/T2A"
if [ -d "$T2A_DIR" ]; then
    echo "Extracting T2A files..."
    mkdir -p "$PROCESSED_DIR/T2A"
    for zip_file in "$T2A_DIR"/*.zip; do
        if [ -f "$zip_file" ]; then
            echo "  Extracting $(basename $zip_file)..."
            7z x "$zip_file" -o"$PROCESSED_DIR/T2A" -y
            if [ $? -ne 0 ]; then
                echo "  Error: Failed to extract $(basename $zip_file)"
                exit 1
            fi
        fi
    done
else
    echo "Warning: T2A directory not found: $T2A_DIR"
fi

V2A_DIR="$RAW_DIR/V2A"
if [ -d "$V2A_DIR" ]; then
    echo "Extracting V2A files..."
    mkdir -p "$PROCESSED_DIR/V2A"
    for zip_file in "$V2A_DIR"/*.zip; do
        if [ -f "$zip_file" ]; then
            echo "  Extracting $(basename $zip_file)..."
            7z x "$zip_file" -o"$PROCESSED_DIR/V2A" -y
            if [ $? -ne 0 ]; then
                echo "  Error: Failed to extract $(basename $zip_file)"
                exit 1
            fi
        fi
    done
else
    echo "Warning: V2A directory not found: $V2A_DIR"
fi

VGGSOUND_ZIP="$RAW_DIR/VGGsound_test_14923_audio_cut.zip"
if [ -f "$VGGSOUND_ZIP" ]; then
    echo "Extracting VGGsound_test_14923_audio_cut.zip..."
    mkdir -p "$PROCESSED_DIR/VGGsound_test_14923_audio_cut"
    7z x "$VGGSOUND_ZIP" -o"$PROCESSED_DIR/VGGsound_test_14923_audio_cut" -y
    if [ $? -ne 0 ]; then
        echo "  Error: Failed to extract VGGsound_test_14923_audio_cut.zip"
        exit 1
    fi
else
    echo "Warning: VGGsound_test_14923_audio_cut.zip not found: $VGGSOUND_ZIP"
fi

echo ""
echo " --- VCapAV dataset extraction complete. Files saved in $PROCESSED_DIR --- "

