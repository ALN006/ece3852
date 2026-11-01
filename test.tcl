source common/proj.tcl
source common/src.tcl
source common/hdl.tcl 
source common/ip/discover.tcl
source common/ip/instance.tcl
source common/ip/spec.tcl

set default_args 	[ source common/default_args.tcl ]
set fpga		[ dict get $default_args fpga_part ]
set project		[ proj::open_vivado ./test $fpga ]

src::register $project sources_1 ./test/rtl
src::show_registered $project sources_1
hdl::set_top $project top

set ip1_spec [ip::spec::load_if_valid test/ip/ip1/ip_spec.tcl]
puts [dict get $ip1_spec name]

proj::close_all


