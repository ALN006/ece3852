namespace eval cfg {
	if { $::argc != 1 } {
		error "cfg.tcl: incorrect number of args"
	}

	variable proj_name		[ lindex $::argv 0 ]

	variable root_dir 		[ file normalize [ file join [ file dirname [ info script ] ] .. ] ]
	variable design_src_dir		$root_dir/$proj_name
	variable vivado_proj_dir	$root_dir/vivado/$proj_name
	variable ip_repo_dir		$root_dir/vivado/ip_repo

	variable part 			xc7s50csga324-1

	proc dump {} {
		puts "\n\n ALNs common tcl var config info:"
		foreach v [ info vars ::cfg::* ] {
			puts "  $v -> [set $v]"
		}
		puts "\n"
	}
}
