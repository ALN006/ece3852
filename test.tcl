source common/proj.tcl
source common/src.tcl

set default_args 	[ source common/default_args.tcl ]
set fpga		[ dict get $default_args fpga_part ]
set project		[ proj::open_vivado ./test $fpga ]

src::register $project sources_1 ./test/rtl
src::show_registered $project sources_1
proj::close_all

