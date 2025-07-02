#
# export_hardware.tcl  Tcl script for export hardware
#
#
# Open Project
#
set script_directory       [file dirname [info script]]
cd $script_directory
cd ..

set project [file normalize [file join [pwd] "zynq/zynq.xpr"]]
open_project $project 

set project_directory [get_property directory [current_project]]
set project_name [get_property name [current_project]]
#
# Make SDK Workspace 
#
if {[info exists sdk_workspace] == 0} {
    set sdk_workspace       [file join $project_directory $project_name.sdk]
}
if { [file exists $sdk_workspace] == 0 } {
    file mkdir $sdk_workspace
}
#
# Copy Hardware File
#
set design_top_name [get_property "top" [current_fileset]]
file copy -force [file join $project_directory $project_name.runs "impl_1" $design_top_name.hwdef] [file join $sdk_workspace $design_top_name.hwdef]
file copy -force [file join $project_directory $project_name.runs "impl_1" $design_top_name.bit] [file join [pwd] "output" $design_top_name.bit]
#
# Close Project
#
close_project
