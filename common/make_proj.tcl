if {$argc < 1} { error "usage requires flag: -tclargs <proj_name>" }

set proj_name		[lindex $argv 0]
set root		[file normalize [file join [file dirname [info script]] ..]]
set design_source_dir	$root/$proj_name
set vivado_proj_dir    	$root/vivado/$proj_name
set part 		xc7s50csga324-1

create_project $proj_name $vivado_proj_dir -part $part -force
add_files [ glob $design_source_dir/rtl/*.sv ]
add_files -fileset constrs_1 $design_source_dir/constraints.xdc
update_compile_order -fileset sources_1
