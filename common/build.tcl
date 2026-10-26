set common_dir [file dirname [file normalize [info script]]]
source $common_dir/environ.tcl
source $common_dir/proj.tcl
source $common_dir/bd.tcl
source $common_dir/util.tcl

# environ cfg dump
cfg::dump
util::demote_msgs {{BD 5-700} {filemgmt 56-443} {IP_Flow 19-4994}}

proj::create $cfg::proj_name $cfg::vivado_proj_dir $cfg::part $cfg::ip_dir

bd::create mb_block
bd::add_mb_system [dict create \
    cpu         microblaze_0 \
    uart        axi_uartlite_0 \
    local_mem   128KB \
    baud        115200 \
    clk_port    clk_100MHz \
    reset_port  reset_rtl_0 \
    uart_port   uart_rtl_0]
bd::finalize mb_block

puts "\n ALNs bd_info: cells: [get_bd_cells] \n"

