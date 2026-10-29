namespace eval ip { 
	proc discover_repositories {} {
		set ip_repo_root [ file join $::root vivado ip_repo]
		set repositories {}

		if {![ file isdirectory $ip_repo_root ]} { return $repositories }

		foreach metadata [ glob -nocomplain -directory $ip_repo_root -types f */component.xml ] {
			lappend repositories [ file dirname $metadata ]
		}
		
		return $repositories
	}
	proc register_repositories {} {
		set repositories [ discover_repositories ]
		if { [ llength $repositories ] == 0 } {
			puts "No custom IP repositories found"
			return
		}
		
		set_property ip_repo_paths $repositories [ current_project ]
		update_ip_catalog

		puts "Registered IP repositories:"
		foreach repository $repositories { puts "  $repository"  }
	}
	proc list_available_ips {} {
		puts "\nAvailable custom IP definitions:"
		foreach ip [get_ipdefs -all *] { puts "  $ip" }
	}
	proc find_ip { target } {
		puts "\n IPs with \"$target\" in the vlnv: "
		set found 0
		foreach vlnv [ get_ipdefs -all * ] {
			if { [ string match -nocase "*${target}*" $vlnv ] } { 
				puts "  $vlnv"
				incr found
			}
		}
		puts "found $found IPs"
	}
	proc load_spec { ip_dir } {
		set spec_file [ file join $ip_dir ip_spec.tcl ]
		if { ![ file isfile $spec_file ] } { error "IP specification no found: $spec_file" }
		
		set spec [ source $spec_file ]
	 	
		foreach field {vendor library name version vlnv dependencies sources ip_dir} {
			if {![dict exists $spec $field]} { error "Missing '$field' in $spec_file" }
		}
		foreach src [dict get $spec sources] {
			if {![file isfile $src]} { error "Source file not found: $src" }
		}
		
		puts "Loaded IP specification: [dict get $spec vlnv]"
		puts "  Sources: [llength [dict get $spec sources]]"
		puts "  Dependencies: [llength [dict get $spec dependencies]]"
		
		return $spec	
	}
	proc validate_dependencies {spec} {
		foreach dependency [dict get $spec dependencies] {
			set vlnv [dict get $dependency vlnv]
			set matches [get_ipdefs -all $vlnv]
			if {[llength $matches] == 0} { error "Required IP dependency not found: $vlnv" }
			
			puts "Found dependency: $vlnv"
			dict for {property value} [dict get $dependency configurations] {
				puts "  $property = $value"
			}
		}
	}
	proc create_configured_ip {dependency output_dir} {
		set vlnv [dict get $dependency vlnv]
		set configurations [dict get $dependency configurations]
		set name [lindex [split $vlnv :] 2]
		set instance [get_ips -quiet $name]

		if {[llength $instance] == 0} {
		       	file mkdir $output_dir	
			create_ip -vlnv $vlnv -module_name $name -dir $output_dir
			set instance [get_ips $name]
			puts "Created IP instance: $name"
		} else {
			puts "Reusing existing IP instance: $name"
		}

		if {[dict size $configurations] > 0} { set_property -dict $configurations $instance }
		return $instance
	}
	proc generate_ip {instance} {
    		generate_target all $instance
    		puts "Generated output products for: $instance"
	}
}

