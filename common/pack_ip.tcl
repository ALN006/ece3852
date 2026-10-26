if {$argc < 2} { error "usage: -tclargs <proj_name> <ip_name>" }
set proj_name [lindex $argv 0]
set ip_name   [lindex $argv 1]

set root    [file normalize [file join [file dirname [info script]] ..]]
set ip_src  $root/$proj_name/ip/$ip_name
set ip_dir  $root/vivado/ip_repo/${ip_name}_1_0
set tmp_dir $root/vivado/ip_tmp/$ip_name
set part    xc7s50csga324-1

puts "\n\n ALNs tcl var info:"
foreach v {root ip_src ip_dir tmp_dir} { puts "  $v = [set $v]  " }

create_project -force ip_pack $tmp_dir -part $part

add_files [glob $ip_src/src/*.sv]

set_property top ${ip_name}_v1_0 [current_fileset]

update_compile_order -fileset sources_1

#straight up delete prev version
file delete -force $ip_dir

#create a ip packing project
ipx::package_project -root_dir $ip_dir -vendor user.org -library user \
    -taxonomy /UserIP -import_files -set_current true

set ip_ref	[ipx::current_core]
set_property name    $ip_name $ip_ref
set_property version 1.0      $ip_ref

# remove 2 miscreated intefaces and create the appropriatw united one hdmi interface
ipx::remove_bus_interface hdmi_clk_n $ip_ref
ipx::remove_bus_interface hdmi_clk_p $ip_ref

set hdmi_if_name HDMI
ipx::add_bus_interface $hdmi_if_name $ip_ref
set hdmi_if_ref [ipx::get_bus_interfaces $hdmi_if_name -of_objects $ip_ref]

# only unclear part of all this
set_property abstraction_type_vlnv xilinx.com:interface:hdmi_rtl:1.0 $hdmi_if_ref
set_property bus_type_vlnv         xilinx.com:interface:hdmi:1.0     $hdmi_if_ref
set_property interface_mode        master                            $hdmi_if_ref

foreach {logical physical} {
    TMDS_CLK_P  hdmi_clk_p
    TMDS_CLK_N  hdmi_clk_n
    TMDS_DATA_P hdmi_tx_p
    TMDS_DATA_N hdmi_tx_n
} {
    ipx::add_port_map $logical $hdmi_if_ref
    set_property physical_name $physical [ipx::get_port_maps $logical -of_objects $hdmi_if_ref]
}

foreach pm [ipx::get_port_maps -of_objects $hdmi_if_ref] {
    puts "  port map: [get_property logical_name $pm] -> [get_property physical_name $pm]"
}

puts "\n\n ALNs ip gen summary:\n  vendor:library:name:version :       [get_property vlnv $ip_ref] \n  interfaces: [get_property name [ipx::get_bus_interfaces -of_objects $ip_ref]] \n  ports:      [get_property name [ipx::get_ports -of_objects $ip_ref]]\n\n"

ipx::save_core $ip_ref

close_project
