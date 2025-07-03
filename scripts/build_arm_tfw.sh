#!/bin/bash
BL31_DEST="$(pwd)/output"
# Check if a path argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/file"
    exit 1
fi

# Store the provided path
BUILD_DIR="$1"

# Check if the directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Directory '$BUILD_DIR' does not exist."
    exit 1
fi

# Change to the specified directory
cd "$BUILD_DIR" || { echo "Failed to cd into '$BUILD_DIR'"; exit 1; }

# Run the make command
echo "Building ARM Trusted Firmware..."
make CROSS_COMPILE=$VIVADO_SDK_PATH/gnu/aarch64/lin/aarch64-linux/bin/aarch64-linux-gnu- \
    ARCH=aarch64 \
    PLAT=zynqmp \
    RESET_TO_BL31=1 
# Check if make succeeded
if [ $? -ne 0 ]; then
    echo "Error: Make command failed."
    exit 1
fi

# Define the path to the generated bl31.elf
BL31_SRC="$BUILD_DIR/build/zynqmp/release/bl31/bl31.elf"


# Copy the file
echo "Copying $BL31_SRC to $BL31_DEST..."
cp "$BL31_SRC" "$BL31_DEST" || { echo "Failed to copy bl31.elf"; exit 1; }

echo "Successfully built and copied bl31.elf!"
exit 0