#!/bin/bash

# Script for dereplicating MAGs using dRep
# dRep version: 3.4.5
# dRep GitHub: https://github.com/MrOlm/drep

# Set the output directory for dRep results
OUTPUT_DIR="drep_output_sort_50_5_99"

# Create the output directory if it does not exist
mkdir -p $OUTPUT_DIR

# Check if dRep is installed and accessible
if ! command -v dRep &> /dev/null; then
    echo "dRep could not be found. Please install dRep and ensure it is in your PATH." >&2
    exit 1
fi

# Run dRep to dereplicate MAGs
dRep dereplicate $OUTPUT_DIR \
    -g Bin_sort_all/*.fa \
    -sa 0.99 \
    -nc 0.30 \
    -p 64 \
    -pa 0.9 \
    -comp 50 \
    -con 5

# Check if dRep was successful
if [ $? -ne 0 ]; then
    echo "dRep dereplication failed!" >&2
    exit 1
fi

echo "dRep dereplication completed successfully. Results are stored in $OUTPUT_DIR."