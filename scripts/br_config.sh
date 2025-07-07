#!/bin/sh

OUTPUT_DIR=$(pwd)/output/buildroot
echo $OUTPUT_DIR
BR_PATH=$1

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

make -C $BR_PATH \
O=$OUTPUT_DIR \
nconfig