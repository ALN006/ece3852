if {$argc < 1} { error "usage requires flag: -tclargs <proj_name>" }

set proj_name		[lindex $argv 0]
set root		[file normalize [file join [file dirname [info script]] ..]]
set design_src_dir	$root/$proj_name
set vivado_proj_dir    	$root/vivado/$proj_name
set ip_dir		$root/vivado/ip_repo
set ip_tmp_dir		$root/vivado/ip_tmp
set part 		xc7s50csga324-1

puts "\n\n ALNs tcl var info: "
foreach v { proj_name root design_src_dir vivado_proj_dir ip_dir ip_tmp_dir part } { puts "  $v = [ set $v ]" }
puts "\n\n"
