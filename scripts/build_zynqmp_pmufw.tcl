#!/usr/bin/tclsh
cd zynq

set app_name          "pmufw"
set app_type          "zynqmp_pmufw"
set hwspec_file       "zynq_wrapper.hwdef"
set proc_name         "psu_pmu_0"
set project_name      "zynq"
set project_dir       [pwd]
set sdk_workspace     [file join $project_dir $project_name.sdk]
set app_dir           [file join $sdk_workspace $app_name]
set app_release_dir   [file join [pwd] ".." "output"]
set app_release_elf   "zynqmp_pmufw.elf"
set hw_design         [hsi::open_hw_design [file join $sdk_workspace $hwspec_file]]

hsi::generate_app -hw $hw_design -os standalone -proc $proc_name -app $app_type -dir $app_dir

exec make -C $app_dir all >&@ stdout

file copy -force [file join $app_dir "executable.elf"] [file join $app_release_dir $app_release_elf]
