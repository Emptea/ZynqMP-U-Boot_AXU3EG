# update_multiplier_ip.tcl

set ip_dir "ip_repo/multiplier_1.0"
set hdl_dir "$ip_dir/hdl"
set component_xml "$ip_dir/component.xml"
set top_module "multiplier_v1_0"

proc make_relative_to_ip {ip_root file_path} {
    set ip_root [file normalize $ip_root]
    set file_path [file normalize $file_path]

    set prefix "${ip_root}/"

    if {[string first $prefix $file_path] != 0} {
        error "File is not under IP root: $file_path ; IP root: $ip_root"
    }

    return [string range $file_path [string length $prefix] end]
}

if {![file exists $component_xml]} {
    error "component.xml not found: $component_xml"
}

if {![file isdirectory $hdl_dir]} {
    error "HDL directory not found: $hdl_dir"
}

puts "Opening IP core: $component_xml"
ipx::open_core $component_xml
set core [ipx::current_core]

puts "Finding Verilog/SystemVerilog files under: $hdl_dir"
set rtl_files [concat \
    [glob -nocomplain -directory $hdl_dir -types f *.v] \
    [glob -nocomplain -directory $hdl_dir -types f *.sv] \
]

# Recursive file search
proc find_rtl_files {dir} {
    set files {}

    foreach f [glob -nocomplain -directory $dir -types f *] {
        if {[regexp {\.s?v$} $f]} {
            lappend files $f
        }
    }

    foreach d [glob -nocomplain -directory $dir -types d *] {
        set files [concat $files [find_rtl_files $d]]
    }

    return $files
}

set rtl_files [lsort -unique [find_rtl_files $hdl_dir]]

if {[llength $rtl_files] == 0} {
    error "No Verilog/SystemVerilog files found in $hdl_dir"
}

puts "RTL files found:"
foreach f $rtl_files {
    puts "  $f"
}

# Remove old HDL file entries from synthesis and simulation file groups

foreach fg_name {"xilinx_verilogsynthesis" "xilinx_verilogbehavioralsimulation"} {
    set fg [ipx::get_file_groups $fg_name -of_objects $core]

    if {$fg eq ""} {
        puts "Creating file group: $fg_name"
        set fg [ipx::add_file_group $fg_name $core]
    }

   # puts "Clearing old HDL files from file group: $fg_name"

    #foreach file_obj [ipx::get_files -of_objects $fg] {
    #    set file_name [get_property name $file_obj]
    #    puts "checking file $file_name for removal"
     #   puts "OBJ=$file_obj"
     #   if {[regexp {\.s?v$} $file_name]} {
     #       puts "removing file $file_name from $fg"
     #       ipx::remove_file -file_group $fg $file_obj
     #   }
    #}

    puts "Adding RTL files to file group: $fg_name"

    foreach f $rtl_files {
        set abs_file [file normalize $f]
        set rel_file [make_relative_to_ip $ip_dir $f]

        puts "Adding $rel_file to [get_property name $fg]"
        ipx::add_file $rel_file $fg
    }
}

puts "==== SYNTH FILE GROUP ===="
set fg [ipx::get_file_groups xilinx_verilogsynthesis -of_objects $core]
foreach f [ipx::get_files -of_objects $fg] {
    puts "  [get_property name $f]"
}

puts "Updating checksums/source archive"
ipx::update_source_project_archive -component $core

puts "Running IP integrity check"
ipx::check_integrity $core

puts "Update IP revision"
set old_rev [get_property core_revision $core]
set_property core_revision [expr {$old_rev + 1}] $core

puts "Saving IP core"
ipx::save_core $core

puts "Done: IP updated and saved."

puts "Reset multiplier"
open_bd_design [get_files */d_1.bd]

report_ip_status

upgrade_ip [get_ips]

reset_target all [get_files */d_1.bd]
generate_target all [get_files */d_1.bd]

validate_bd_design
save_bd_design

reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
