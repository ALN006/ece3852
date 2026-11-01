namespace eval ip::spec {
	proc load_if_valid { spec_file } {
		set spec_file [file normalize $spec_file]
		if {![file isfile $spec_file]} { error "IP specification does not exist: $spec_file" }
		
		set spec [source $spec_file]
		if {[catch {dict size $spec}]} { error "Invalid IP specification: expected a dictionary."  }

		foreach key {vendor library name version sources dependencies software} {
			if {![dict exists $spec $key]} {
				error "Invalid IP specification: missing required field '$key'."
			}
		}
		set sources [dict get $spec sources]
		if {[llength $sources] == 0} { error "IP specification contains no source files." }

		foreach source $sources {
			if {![file isfile $source]} { error "IP source file does not exist: $source" }
		}
		return $spec
	}
}

