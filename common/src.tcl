namespace eval src {
	proc add_hdl {project_name} {
		#add project opening/verifying code here
		set src_dir [file join $::root $project_name src]
		if {![file isdirectory $src_dir]} { error "RTL directory does not exist: $src_dir" }
		
		set hdl_files [ glob -nocomplain $src_dir/*.sv $src_dir/rtl/*.v ]
		if { [ llength $hdl_files ] == 0 } { error "No hdl files found in $::root/$project_name/rtl" }
		
		set existing_files [get_files -quiet]
		set added_count 0
		foreach file $hdl_files {
			set normalized_file [file normalize $file]
			if {[lsearch -exact $existing_files $normalized_file] == -1} {
				add_files -norecurse $normalized_file
				incr added_count
				puts "Registered HDL: $normalized_file"
			}
		}
		puts "Added $added_count new HDL files."
	}
}

