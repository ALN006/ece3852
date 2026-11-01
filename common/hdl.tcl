 namespace eval hdl {
        proc set_top { project top_module } {
		current_project $project
                set source_files [get_files -quiet -of_objects [get_filesets sources_1]]
                if { [ llength $source_files ] == 0 } { error "Cannot set top '$top_module': no source files are registered." }

                set_property top $top_module [ get_filesets sources_1 ]
                update_compile_order -fileset sources_1

                set resolved_top [ get_property top [ get_filesets sources_1 ] ]
                puts "Top-level module set to: $resolved_top"
	}
}	
