namespace eval src {
	proc register { project fileset src_dir } {
		current_project $project
		if {[llength [get_filesets -quiet $fileset]] == 0} { error "Fileset does not exist: $fileset" }
		set src_dir [ file normalize $src_dir ]
		if {![file isdirectory $src_dir]} { error "source directory does not exist: $src_dir" }
		
		set src_files [ glob -nocomplain $src_dir/*.sv $src_dir/*.v $src_dir/*.xdc ]
		if { [ llength $src_files ] == 0 } { error "No source files found in $src_dir" }

		set existing_files [get_property -quiet NAME [get_files -quiet -of_objects [get_filesets $fileset]]]
		set added_count 0
		foreach src_file $src_files {
			if {[lsearch -exact $existing_files $src_file] == -1} {
				add_files -norecurse -fileset $fileset $src_file
				lappend existing_files $src_file
				incr added_count
				puts "Registered source: $src_file"
			}
		}
		puts "Added $added_count new source files."
	}
	proc show_registered { project fileset } {
		current_project $project
		if { [ llength [ get_filesets -quiet $fileset ] ] == 0 } { error "fileset does not exist: $fileset" }

		set file_objs [get_files -quiet -of_objects [get_filesets $fileset]]

		if { [ llength $file_objs ] == 0 } { 
			puts "No files registered in $fileset."
			return
		}

		foreach file_obj $file_objs { puts [ get_property NAME $file_obj ] }
	}
	proc unregister { project fileset src_file } {
		current_project $project
		if {[llength [get_filesets -quiet $fileset]] == 0} { error "Fileset does not exist: $fileset" }

		set src_file [file normalize $src_file]
		set src_file_obj [get_files -quiet -of_objects [get_filesets $fileset] $src_file]

		if {[llength $src_file_obj] == 0} { error "File is not registered in $fileset: $src_file" }

		remove_files $src_file_obj
		puts "Unregistered: $src_file"
	}
	proc delete { project fileset src_file } {
		current_project $project
		set src_file [file normalize $src_file]

		if {![file isfile $src_file]} { error "File does not exist: $src_file" }

		unregister $fileset $src_file
		file delete $src_file

		puts "Deleted: $src_file"
	}
}

