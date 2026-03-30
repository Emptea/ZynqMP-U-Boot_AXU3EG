VIVADO ?= vivado
XSCT ?= xsct
BOOTGEN ?= bootgen
NPROC ?= $(shell nproc)

VIVADO_SDK_PATH ?=
ARM_TFW_DIR ?=
DEVICE_TREE_XLNX_DIR ?=
U_BOOT_XLNX_DIR ?=
LINUX_XLNX_DIR ?=
OUTPUT_DIR ?= output
SCRIPTS_DIR ?= scripts

XSA ?= $(OUTPUT_DIR)/project.xsa
HWDEF ?= $(OUTPUT_DIR)/project.hwdef
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

dtb: dts
	@test -d "$(DEVICE_TREE_XLNX_DIR)" || (echo "DEVICE_TREE_XLNX_DIR is required"; exit 1)
	./$(SCRIPTS_DIR)/dtb_gen.sh $(DEVICE_TREE_XLNX_DIR) $(OUTPUT_DIR)

uboot:
	@test -n "$(U_BOOT_XLNX_DIR)" || (echo "U_BOOT_XLNX_DIR is required"; exit 1)
	./$(SCRIPTS_DIR)/uboot_build.sh $(U_BOOT_XLNX_DIR) $(UBOOT_DTB)

bootbin:
	cd $(OUTPUT_DIR) && $(BOOTGEN) -image boot.bif -o BOOT.bin -arch zynqmp -w

clean:
	rm -rf $(OUTPUT_DIR)/*

help:
	@echo "Targets: all vivado_project vivado_impl export_hardware fsbl pmufw arm_tfw dts dtb uboot verify_boot bootbin  clean"