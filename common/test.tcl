set script_dir [ file dirname [ file normalize [ info script ] ] ]
set args [ source $script_dir/default_args.tcl ]

dict set args project_name "lab6"

puts "[ dict get $args project_name ]"

