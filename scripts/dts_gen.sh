#!/bin/bash

# Usage: ./generate_dts.sh <project.xsa> <device-tree-xlnx-path> <output_dir>

PROJ_FILE=$1
DT_REPO_PATH=$2
OUTPUT_DIR=${3:-$(pwd)/output/dts}  # Default output dir

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

# Modify file for SD card
cd $OUTPUT_DIR
PCW_FILE="pcw.dtsi"
if [ ! -f "$PCW_FILE" ]; then
    echo "Error: $PCW_FILE not found!" >&2
    exit 1
fi
cp "$PCW_FILE" "$PCW_FILE.bak"
awk '
/sdhci0/ { in_node=1 }
in_node && /{/ { brace_count++; print; next }
in_node && /}/ { 
    brace_count--;
    if (brace_count == 0) {
        print "\tdisable-wp;";
        print "\tno-1-8-v;";
        print "\tu-boot,dm-pre-reloc;";
        in_node=0;
    }
}
in_node { print }
!in_node { print }
' "$PCW_FILE.bak" > "$PCW_FILE"

echo "Updated $PCW_FILE successfully. Backup saved as $PCW_FILE.bak"

cat system-top.dts system.dts  > zynqmp.dts && \
    gcc -E -nostdinc -undef -x assembler-with-cpp \
    -o system-merged.dts \
    zynqmp.dts
rm zynqmp.dts
cp system-merged.dts ../zynqmp.dts

cd ..
echo $(pwd)
dtc -I dts -O dtb -o zynqmp.dtb zynqmp.dts

echo "Successfully built dts. Output written to $(pwd)/output/"
exit 0