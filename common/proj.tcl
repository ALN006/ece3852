namespace eval proj { 
	proc open_prj {project_name} {
		set project_dir [file join $::root vivado $project_name]
		set project_file [file join $project_dir "${project_name}.xpr"]

		file mkdir [file dirname $project_dir]

		if { [ file exists $project_file ] } { 
			puts "Opening existing project: $project_file"
			open_project $project_file
		} else {
			create_project  $project_name $project_dir -part $::cfg::fpga_part
			puts "Created project: $project_name"
			puts "Project directory: $project_dir"
			puts "FPGA part: $::cfg::fpga_part"
		}
	}
	#sus, needs checks on current project and fileset
	proc set_top {top_module} {
		set source_files [get_files -quiet -of_objects [get_filesets sources_1]]
		if {[llength $source_files] == 0} { error "Cannot set top '$top_module': no source files are registered." }

		set_property top $top_module [current_fileset]
		update_compile_order -fileset sources_1

		set resolved_top [get_property top [current_fileset]]
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
		launch_runs impl_1 -to_step write_bitstream -jobs $jobs
		wait_on_run impl_1
		set status [get_property STATUS [get_runs impl_1]]
		puts "Implementation status: $status"
		if {![string match "*Complete*" $status]} {
			error "Implementation failed: $status"
		}
	}
	proc run_target {target jobs} {
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
