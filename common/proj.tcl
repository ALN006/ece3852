namespace eval proj { 
	proc open_vivado { project_dir fpga } {
		if {![file isdirectory $project_dir]} { error "Project directory does not exist: $project_dir" }
		set normalized_project_dir [ file normalize $project_dir ]

		set project_name [ file tail $normalized_project_dir ]
		set vivado_project_dir [ file join $normalized_project_dir vivado_project ]
		set vivado_project_file [ file join $vivado_project_dir "${project_name}.xpr" ]

		file mkdir $vivado_project_dir
		if { [ file exists $vivado_project_file ] } { 
			puts "Opening existing project: $vivado_project_file"
			open_project $vivado_project_file
		} else {
			create_project  $project_name $vivado_project_dir -part $fpga
			puts "Created vivado project: $project_name"
			puts "Project directory: $vivado_project_dir"
			puts "FPGA used: $fpga"
		}
		return [ current_project ]
	}
	proc close_all {} {
		while { [ catch { current_project} ] == 0} { close_project }
	}
	#sus, needs checks on current project and fileset
	proc set_top {top_module} {
		set source_files [get_files -quiet -of_objects [get_filesets sources_1]]
		if {[llength $source_files] == 0} { error "Cannot set top '$top_module': no source files are registered." }

		set_property top $top_module [ get_filesets sources_1 ]
		update_compile_order -fileset sources_1

		set resolved_top [ get_property top [ get_filesets sources_1 ] ]
		puts "Top-level module set to: $resolved_top"
	}
	proc synthesize {jobs} {
		puts "Starting synthesis..."
		reset_run synth_1
		launch_runs synth_1 -jobs $jobs
		wait_on_run synth_1

		set status [get_property STATUS [get_runs synth_1]]
		puts "Synthesis status: $status"

		if {![string match "*Complete*" $status]} {
			error "Synthesis failed: $status"
		 }
	}
	proc implement {jobs} {
		puts "Starting implementation..."
		reset_run impl_1
		launch_runs impl_1 -to_step write_bitstream -jobs $jobs
		wait_on_run impl_1

		set status [get_property STATUS [get_runs impl_1]]
		puts "Implementation status: $status"
		if {![string match "*Complete*" $status]} {
			error "Implementation failed: $status"
		}
	}
	proc run_target {project target jobs} {
		current_project $project
		switch -- $target {
			sources { puts "Sources registered. Skipping synthesis."  }
			synth { synthesize $jobs }
			all {
				synthesize $jobs
				implement $jobs
			}
			default { error "Unsupported build target: $target" }
		}
	}
}
