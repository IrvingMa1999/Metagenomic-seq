#!/bin/bash

# Set working directory
WORK_DIR="/path/to/your/working/directory"
cd $WORK_DIR

# Input files
FORWARD_READS="sample1_R1.fastq.gz"
REVERSE_READS="sample1_R2.fastq.gz"

# Output directory for assembly
ASSEMBLY_DIR="assembly_contig"
mkdir -p $ASSEMBLY_DIR

# Step 3: Assembly with MEGAHIT
megahit \
-1 $FORWARD_READS \
-2 $REVERSE_READS \
-o $OUTPUT_DIR \
--k-min 39 \
--k-max 141 \
--k-step 20

# Check if assembly was successful
if [ $? -ne 0 ]; then
    echo "MEGAHIT assembly failed!" >&2
    exit 1
fi

# Step 4: Mapping and binning preprocessing
# Build Bowtie2 index
bowtie2-build \
-f $ASSEMBLY_DIR/R1.contigs.fa $ASSEMBLY_DIR/R1.contigs

# Mapping reads to the assembled contigs
bowtie2 -q --fr \
-x $ASSEMBLY_DIR/R1.contigs \
-1 $FORWARD_READS \
-2 $REVERSE_READS \
-S sample1.sam \
-p 64

# Convert SAM to BAM
samtools view -h -b -S sample1.sam -o sample1.bam -@ 64

# Filter mapped reads
samtools view -b -F 4 sample1.bam -o sample1.mapped.bam -@ 64

# Sort the mapped BAM file
samtools sort \
-m 1000000000 sample1.mapped.bam \
-o sample1.mapped.sorted.bam -@ 64

# Step 5: Binning using Easy single binning mode with SemiBin
SEMI_BIN_OUTPUT="easy_single_sample_output"
SemiBin single_easy_bin \
-i $ASSEMBLY_DIR/R1.contigs.fa \
-b sample1.mapped.sorted.bam \
-o $SEMI_BIN_OUTPUT

# Check if SemiBin was successful
if [ $? -eq 0 ]; then
    echo "Binning with SemiBin completed successfully."
else
    echo "Binning with SemiBin failed!" >&2
    exit 1
fi

echo "All steps completed successfully."