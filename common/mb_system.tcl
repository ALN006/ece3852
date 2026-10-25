# known-benign messages: still printed, but as INFO instead of WARNING
foreach id {{BD 5-700} {filemgmt 56-443} {IP_Flow 19-4994}} {
    set_msg_config -id $id -severity WARNING -new_severity INFO
}

set bd_name	mb_block
set local_mem	128KB
set cpu_name	microblaze_0
set uart_name	axi_uartlite_0

create_bd_design $bd_name

create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze $cpu_name

apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config \
       	[ list axi_intc 1 axi_periph Enabled cache None clk {New Clocking Wizard} cores 1 debug_module {Debug Only} ecc None local_mem $local_mem preset Microcontroller ] \
	[ get_bd_cells $cpu_name ]

puts "\n\n ALNs address space sanity check (should see a /$cpu_name/Data and /$cpu_name/Instruction): [ get_bd_addr_spaces /$cpu_name/* ] \n\n"

delete_bd_objs [get_bd_nets ${cpu_name}_intr] [get_bd_cells ${cpu_name}_xlconcat]

set_property CONFIG.PRIM_SOURCE Single_ended_clock_capable_pin [get_bd_cells clk_wiz_1]

# UART Lite
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite $uart_name
set_property CONFIG.C_BAUDRATE 115200 [ get_bd_cells $uart_name ]
#connection automation
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
	[list Clk_master {/clk_wiz_1/clk_out1 (100 MHz)} Clk_slave Auto Clk_xbar {/clk_wiz_1/clk_out1 (100 MHz)} Master "/$cpu_name (Periph)" Slave /$uart_name/S_AXI \
	ddr_seg Auto intc_ip /${cpu_name}_axi_periph master_apm 0] \
	[get_bd_intf_pins $uart_name/S_AXI]
#interupt connection
connect_bd_net [get_bd_pins $uart_name/interrupt] [get_bd_pins ${cpu_name}_axi_intc/intr] 

#NOTE: the next 3 blocks of code are not exact copies of the tcl from gui but it should work the same

# external ports
set clk_port    clk_100MHz
set reset_port  reset_rtl_0
set uart_port   uart_rtl_0

# UART pins
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 $uart_port
connect_bd_intf_net [get_bd_intf_ports $uart_port] [get_bd_intf_pins $uart_name/UART]

# 100 MHz board clock into the clocking wizard
create_bd_port -dir I -type clk -freq_hz 100000000 $clk_port
connect_bd_net [get_bd_ports $clk_port] [get_bd_pins clk_wiz_1/clk_in1]

# reset button, active low inside the block design
create_bd_port -dir I -type rst $reset_port
set_property CONFIG.POLARITY ACTIVE_LOW [get_bd_ports $reset_port]
connect_bd_net [get_bd_ports $reset_port] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]

puts "\n\n ALNs reset sanity check (must be ACTIVE LOW): [get_property CONFIG.POLARITY [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]] \n\n"

validate_bd_design

generate_target all [get_files ${bd_name}.bd]

puts "\n\n ALNs info block design info: $bd_name ports: [get_bd_ports] [get_bd_intf_ports] \n\n"

save_bd_design
