#!/bin/bash

# Usage: ./generate_dts.sh <project.xsa> <device-tree-xlnx-path> <output_dir>

PROJ_FILE=$1
DT_REPO_PATH=$2
OUTPUT_DIR=${3:-$(pwd)/output}  # Default output dir
OUTPUT_DTS_DIR=$OUTPUT_DIR/dts/

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
hsi::generate_target -dir "$OUTPUT_DTS_DIR"
hsi::close_hw_design [hsi current_hw_design]
EOF

echo "Device tree generated in: $OUTPUT_DTS_DIR"
USER_FILE="user.dts"
if [ -f "$OUTPUT_DIR/$USER_FILE" ]; then
    cp $OUTPUT_DIR/$USER_FILE $OUTPUT_DTS_DIR/$USER_FILE
    echo "Copied $OUTPUT_DIR/$USER_FILE to $OUTPUT_DTS_DIR/$USER_FILE"
elif [ -f "$(pwd)/$USER_FILE" ]; then
    cp $(pwd)/$USER_FILE $OUTPUT_DTS_DIR/$USER_FILE
    echo "Copied $(pwd)/$USER_FILE to $OUTPUT_DTS_DIR/$USER_FILE"
else
    echo "Warning: $USER_FILE not found. Creating empty file."
    touch $OUTPUT_DTS_DIR/$USER_FILE
fi

cd $OUTPUT_DTS_DIR

if [ -f "$OUTPUT_DTS_DIR/pl.dtsi" ]; then
    cat system-top.dts system.dts pcw.dtsi pl.dtsi user.dts > zynqmp.dts
else
    cat system-top.dts system.dts pcw.dtsi user.dts > zynqmp.dts
fi 

cp zynqmp.dts ../zynqmp.dts

echo "Successfully built dts. Output written to $OUTPUT_DIR"
exit 0