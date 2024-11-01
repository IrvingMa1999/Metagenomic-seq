#!/bin/bash

# Activate the conda environment for GTDB-Tk
# Uncomment the next line if you need to activate the environment
# conda activate gtdbtk

# GTDB-Tk version: 2.3.2

# Copy dereplicated genomes from the specified path to the current directory
cp -r /yourpath/drep_output_sort_50_5/dereplicated_genomes .

# Create output directory for classification results
CLASSIFY_OUT_DIR="classify_wf"
mkdir -p $CLASSIFY_OUT_DIR

# Classify genomes using GTDB-Tk
gtdbtk classify_wf \
    --genome_dir dereplicated_genomes \
    --out_dir $CLASSIFY_OUT_DIR \
    --extension fa \
    --prefix bin \
    --skip_ani_screen \
    --cpus 64

# Check if classification was successful
if [ $? -ne 0 ]; then
    echo "GTDB-Tk classification failed!" >&2
    exit 1
fi

# Create output directory for inference results
OUT_INFER_DIR="out_infer"
mkdir -p $OUT_INFER_DIR

# Inference using GTDB-Tk with FastTree
# Inference for bac120 MSA
gtdbtk infer --msa_file align/bin.bac120.user_msa.fasta --out_dir ${OUT_INFER_DIR}_bac120 --cpus 64 --prefix bin

# Check if bac120 inference was successful
if [ $? -ne 0 ]; then
    echo "GTDB-Tk inference for bac120 failed!" >&2
    exit 1
fi

# Inference for ar53 MSA
gtdbtk infer --msa_file align/bin.ar53.user_msa.fasta --out_dir ${OUT_INFER_DIR}_ar53 --cpus 64 --prefix bin

# Check if ar53 inference was successful
if [ $? -ne 0 ]; then
    echo "GTDB-Tk inference for ar53 failed!" >&2
    exit 1
fi

echo "All steps completed successfully."