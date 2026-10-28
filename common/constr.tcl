namespace eval constr {
	proc add_xdc {project_name} {
		#add project check here
		set constr_dir [file join $::root $project_name constraints]
		if {![file isdirectory $constr_dir]} { error "Constraints dir does not exist: $constr_dir" }
		set xdc_files [glob -nocomplain [file join $constr_dir *.xdc]]

		if {[llength $xdc_files] == 0} {
        		puts "No XDC files found in $::root/$project_name/constraints"
            		return
        	}
		set existing_files [get_files -quiet -of_objects [get_filesets constrs_1]]
		set added_count 0

		foreach file $xdc_files {
			set normalized_file [file normalize $file]
			if {[lsearch -exact $existing_files $normalized_file] == -1} {
				add_files -fileset constrs_1 -norecurse $normalized_file
				incr added_count
				puts "Registered XDC: $normalized_file"
			}
		}
		puts "Added $added_count new XDC files."
	}
}

