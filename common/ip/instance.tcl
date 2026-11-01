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

}
