#note all specified paths must be relative to the directory containing this file
set ip_dir_ [ file dirname  [ info script ] ]
return [ dict create \
	ip_dir $ip_dir_	\
	vendor "user.org" \
	library "user" \
	name "[ file tail $ip_dir_ ]" \
	version "1.0" \
	sources [ glob -nocomplain [file join $ip_dir_ rtl *.sv] [file join $ip_dir_ rtl *.v]] \
	dependencies [ list \
		[ dict create \
			vlnv "xilinx.com:ip:clk_wiz:6.0" \
			configurations [ dict create \
				CONFIG.PRIM_IN_FREQ 100.0 \
			] \
		] \
	] \
	software [ dict create \
		driver_c	[ glob -nocomplain [file join $ip_dir_ drivers *.c] ] \
		driver_h	[ glob -nocomplain [file join $ip_dir_ drivers *.h] ] \
		makefile $ip_dir_/makefile \
	] \
]

