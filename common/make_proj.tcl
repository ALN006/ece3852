if {$argc < 1} { error "usage requires flag: -tclargs <proj_name>" }

set proj_name		[lindex $argv 0]
set design_source_dir	C:/Users/adityal2/Desktop/ece385/$proj_name
set vivado_proj_dir    	C:/Users/adityal2/Desktop/ece385/vivado/$proj_name
set part 		xc7s50csga324-1

create_project $proj_name $vivado_proj_dir -part $part -force
add_files [ glob $design_source_dir/rtl/*.sv ]
update_compile_order -fileset sources_1
