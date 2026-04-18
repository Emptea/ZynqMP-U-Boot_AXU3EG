VIVADO ?= vivado
XSCT ?= xsct
BOOTGEN ?= bootgen
NPROC ?= $(shell nproc)

VIVADO_SDK_PATH ?= /tools/Xilinx/SDK/2019.1/
ARM_TFW_DIR ?= /home/a/tools/arm-trusted-firmware/
DEVICE_TREE_XLNX_DIR ?= /home/a/tools/device-tree-xlnx/
U_BOOT_XLNX_DIR ?= /home/a/tools/u-boot-xlnx/
LINUX_XLNX_PATH ?= /home/a/tools/linux-xlnx/
OUTPUT_DIR ?= output
SCRIPTS_DIR ?= scripts

export VIVADO_SDK_PATH
export ARM_TFW_DIR
export DEVICE_TREE_XLNX_DIR
export U_BOOT_XLNX_DIR

XSA ?= $(OUTPUT_DIR)/d_1_wrapper.xsa
HWDEF ?= $(OUTPUT_DIR)/d_1_wrapper.hwdef
DT_SRC ?= $(OUTPUT_DIR)/zynqmp.dts
DTB ?= $(OUTPUT_DIR)/zynqmp.dtb
UBOOT_DTB ?= $(DTB)
BOOT_BIF ?= $(OUTPUT_DIR)/boot.bif
BOOT_BIN ?= $(OUTPUT_DIR)/BOOT.bin

.PHONY: all vivado_project vivado_impl export_hardware fsbl pmufw arm_tfw dts dtb uboot verify_boot bootbin clean help

all: vivado_project vivado_impl export_hardware fsbl pmufw arm_tfw dts dtb uboot bootbin

vivado_project:
	$(VIVADO) -mode batch -source ./$(SCRIPTS_DIR)/create_project.tcl

vivado_impl:
	$(VIVADO) -mode batch -source ./$(SCRIPTS_DIR)/implementation.tcl

export_hardware:
	$(VIVADO) -mode batch -source ./$(SCRIPTS_DIR)/export_hardware.tcl

fsbl:
	$(XSCT) ./$(SCRIPTS_DIR)/fsbl_build.tcl

pmufw:
	$(XSCT) ./$(SCRIPTS_DIR)/pmufw_build.tcl

arm_tfw:
	@test -n "$(ARM_TFW_DIR)" || (echo "ARM_TFW_DIR is required"; exit 1)
	@test -n "$(VIVADO_SDK_PATH)" || (echo "VIVADO_SDK_PATH is required"; exit 1)
	./$(SCRIPTS_DIR)/arm_tfw_build.sh $(ARM_TFW_DIR)

dts:
	@test -n "$(DEVICE_TREE_XLNX_DIR)" || (echo "DEVICE_TREE_XLNX_DIR is required"; exit 1)
	@if [ -f "$(XSA)" ]; then \
		./$(SCRIPTS_DIR)/dts_gen.sh $(XSA) $(DEVICE_TREE_XLNX_DIR); \
	elif [ -f "$(HWDEF)" ]; then \
		./$(SCRIPTS_DIR)/dts_gen.sh $(HWDEF) $(DEVICE_TREE_XLNX_DIR); \
	else \
		echo "Neither $(XSA) nor $(HWDEF) exists"; exit 1; \
	fi

dtb:
	@test -d "$(LINUX_XLNX_PATH)" || (echo "LINUX_XLNX_DIR is required"; exit 1)
	./$(SCRIPTS_DIR)/dtb_gen.sh $(LINUX_XLNX_PATH) $(OUTPUT_DIR)/dts

uboot:
	@test -n "$(U_BOOT_XLNX_DIR)" || (echo "U_BOOT_XLNX_DIR is required"; exit 1)
	./$(SCRIPTS_DIR)/uboot_config.sh $(U_BOOT_XLNX_DIR) $(UBOOT_DTB)
	./$(SCRIPTS_DIR)/uboot_build.sh $(U_BOOT_XLNX_DIR) $(UBOOT_DTB)

bootbin:
	cd $(OUTPUT_DIR) && $(BOOTGEN) -image boot.bif -o BOOT.bin -arch zynqmp -w

clean:
	rm -rf $(OUTPUT_DIR)/*

help:
	@echo "Targets: all vivado_project vivado_impl export_hardware fsbl pmufw arm_tfw dts dtb uboot bootbin  clean"