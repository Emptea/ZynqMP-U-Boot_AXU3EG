#
# implementation.tcl  Tcl script for implementation
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
# Run Synthesis
#
launch_runs synth_1 -job 4
wait_on_run synth_1
#
# Run Implementation
#
launch_runs impl_1  -job 4
wait_on_run impl_1
open_run    impl_1
report_utilization -file [file join $project_directory "project.rpt" ]
report_timing      -file [file join $project_directory "project.rpt" ] -append
#
# Write Bitstream File
#
launch_runs impl_1 -to_step write_bitstream -job 4
wait_on_run impl_1
#
# Close Project
#
close_project
