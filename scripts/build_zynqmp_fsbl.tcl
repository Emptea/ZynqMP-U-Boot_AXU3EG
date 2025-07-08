#!/usr/bin/tclsh

cd zynq

set app_name          "fsbl"
set app_type          "zynqmp_fsbl"
set hwspec_file       "zynq_wrapper.hwdef"
set proc_name         "psu_cortexa53_0"
set project_name      "zynq"
set project_dir       [pwd]
set sdk_workspace     [file join $project_dir $project_name.sdk]
set app_dir           [file join $sdk_workspace $app_name]
set app_release_dir   [file join [pwd] ".." "output" ]
set app_release_elf   "zynqmp_fsbl.elf"

hsi::open_hw_design [file join $sdk_workspace $hwspec_file]

set sw_fsbl [hsi::create_sw_design $app_name -proc $proc_name -app $app_type]

common::set_property -name APP_COMPILER_FLAGS -value "-DFSBL_NAND_EXCLUDE_VAL=1" -objects $sw_fsbl
hsi::generate_app -sw $sw_fsbl -compile -dir $app_dir
file copy -force [file join $app_dir "executable.elf"] [file join $app_release_dir $app_release_elf]

set design_name [hsi::current_hw_design]
hsi::close_hw_design $design_name