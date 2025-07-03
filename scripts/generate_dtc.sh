#!/bin/bash

# Usage: ./generate_dts.sh <project.xsa> <device-tree-xlnx-path> <output_dir>

PROJ_FILE=$1
DT_REPO_PATH=$2
OUTPUT_DIR=${3:-$(pwd)/output}  # Default output dir

# Check inputs
if [ -z "$PROJ_FILE" ] || [ -z "$DT_REPO_PATH" ]; then
    echo "Usage: $0 <project.xsa/project.hwdef> <device-tree-xlnx-path> [output_dir]"
    exit 1
fi

# Generate the device tree
xsct <<EOF
hsi::open_hw_design "$PROJ_FILE"
hsi::set_repo_path "$DT_REPO_PATH"
hsi::create_sw_design device-tree -os device_tree -proc psu_cortexa53_0
hsi::generate_target -dir "$OUTPUT_DIR"
hsi::close_hw_design [hsi current_hw_design]
EOF

echo "Device tree generated in: $OUTPUT_DIR"