set _self	[ file normalize [ info script ] ]
set lib_dir	[ file dirname $_self ]

foreach f [ glob -nocomplain -type f $lib_dir/*.tcl ] {
	set f_norm [ file normalize $f ]
	if { $f_norm == $f } { continue }
	source $f_norm	
}

unset lib_dir _self f f_norm
