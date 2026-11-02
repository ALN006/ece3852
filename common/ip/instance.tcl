namespace eval ip::instance {
	proc delete { project ip_name } {
		current_project $project

		set ip      	[get_ips $ip_name]
		if {[llength $ip] == 0} { error "IP instance does not exist: $ip_name" }
		set ip_srcs_dir	[ get_property IP_DIR $ip ]
		set ip_gen_dir	[ get_property IP_OUTPUT_DIR $ip ] 
		
		export_ip_user_files -of_objects [get_files ${ip_name}.xci] -no_script -reset -force -quiet
                remove_files [get_files ${ip_name}.xci]
		
		puts "deleting ip_srcs_dir: $ip_srcs_dir"
		file delete -force $ip_srcs_dir
		puts "deleting ip_gen_dir: $ip_gen_dir"
		if {[file isdirectory $ip_gen_dir]} { file delete -force $ip_gen_dir }
	}
	proc register_default_config { project dependency config_name } {
		current_project $project

		set vlnv 		[dict get $dependency vlnv]
		set vlnv_as_a_list 	[split $vlnv :]

		if { [ llength $vlnv_as_a_list ] != 4 } { error "Invalid IP VLNV: $vlnv" }
		lassign $vlnv_as_a_list vendor library name version
		set module_name ${name}_${config_name}

		create_ip \
			-vendor $vendor \
			-library $library \
			-name $name \
			-version $version \
			-module_name $module_name
		
		return [ get_ips $module_name ]
	}	
}
