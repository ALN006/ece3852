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
