namespace eval ip::discover {
	proc vlnvs_with_target_as_substring { project target } {
                current_project $project
                set found 0
                foreach vlnv [ get_ipdefs -all * ] {
                        if { [ string match -nocase "*${target}*" $vlnv ] } {
                                puts $vlnv
                                incr found
                        }
                }
                puts "Found $found IPs."
        }
	proc configurable_properties { project ip } {
		current_project $project
		set properties [ list_property -quiet $ip ]

		foreach property $properties {
			if {[string match "CONFIG.*" $property]} {
				puts "$property = [get_property $property $ip]"
			}
		}
	}
}

