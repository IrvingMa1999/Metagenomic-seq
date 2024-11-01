#!/bin/bash

# Create conda environment from the specified .yml file
# Uncomment the line below to create the environment if needed
# conda env create -f /home/zhuang/METABOLIC/METABOLIC_v4.0_env.yml

# Set the GTDBTK_DATA_PATH environment variable
# Uncomment the line below to set the variable if needed
# conda env config vars set GTDBTK_DATA_PATH="/home/zhuang/database/gtdbtk/release214/"

# Activate the METABOLIC conda environment
# Uncomment the line below if you need to activate the environment
# conda activate METABOLIC_v4.0

# Change to the METABOLIC running folder
# Uncomment the line below if you're in the appropriate directory
# cd METABOLIC_running_folder

# Clone the METABOLIC repository if not already cloned
if [ ! -d "METABOLIC" ]; then
    git clone https://github.com/AnantharamanLab/METABOLIC.git
fi

# Change to the METABOLIC directory
cd METABOLIC

# Run the setup script, assuming it needs to be executed
bash run_to_setup.sh

# Define the path to the metabolic bin directory
METABOLIC_BIN_DIR=~/metaBinall/METABOLIC/metabolic_bin

# Copy the filtered bin files into the metabolic_bin directory
# Uncomment and adjust the path as necessary
# cp -r ~/metaBinall/gtdbtk/BIN_fasta_out $METABOLIC_BIN_DIR

# Change to the metabolic bin directory
cd $METABOLIC_BIN_DIR

# Run the METABOLIC-C.pl script with the specified parameters
perl METABOLIC-C.pl -in-gn ./Bin_pick -r ./META.txt -t 64 --tax phylum -o out_METABOL_C_113

# Check if the METABOLIC-C.pl script was successful
if [ $? -ne 0 ]; then
    echo "METABOLIC-C.pl execution failed!" >&2
    exit 1
fi

echo "METABOLIC-C.pl executed successfully. Output stored in out_METABOL_C_113."