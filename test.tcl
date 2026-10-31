source common/proj.tcl
source common/src.tcl

set default_args 	[ source common/default_args.tcl ]
set fpga		[ dict get $default_args fpga_part ]

proj::open_vivado ./test $fpga
src::register sources_1 ./test/rtl
src::show_registered sources_1
src::delete sources_1 ./test/rtl/other.sv
src::show_registered sources_1
