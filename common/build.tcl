set common_dir [file dirname [file normalize [info script]]]
source $common_dir/environ.tcl
source $common_dir/proj.tcl
source $common_dir/bd.tcl
source $common_dir/util.tcl
source $common_dir/ip.tcl

# environ cfg dump
cfg::dump
util::demote_msgs {{BD 5-700} {filemgmt 56-443} {IP_Flow 19-4994}}

set ip_name hdmi_text_controller
set ip_ver  1.0

set ip_root [ip::generate_stock_axi_lite_peripheral $ip_name $ip_ver $cfg::ip_dir $cfg::ip_tmp_dir $cfg::part]
ip::open_edit $ip_name $ip_root $cfg::ip_tmp_dir $cfg::part
ip::swap_sources $ip_name $ip_ver $ip_root $cfg::design_src_dir/ip/$ip_name/src
ip::add_hdmi_interface
ip::import_driver $ip_name $ip_root $cfg::design_src_dir/ip/$ip_name/drivers
ip::repackage 1

util::close_all_open_projects

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
bd::add_axi_ip microblaze_0 xilinx.com:user:$ip_name:$ip_ver ${ip_name}_0
bd::export_intf ${ip_name}_0/HDMI hdmi
bd::finalize mb_block


puts "BD ports      : [get_bd_ports]"
puts "BD intf ports : [get_bd_intf_ports]"
puts "\n ALNs bd_info: cells: [get_bd_cells] \n"


proj::add_sources $cfg::design_src_dir/rtl/top.sv \
                  $cfg::design_src_dir/constraints.xdc \
                  top

puts "top module : [get_property top [current_fileset]]"
puts "constraints: [get_files -of_objects [get_filesets constrs_1]]"

util::close_all_open_projects

