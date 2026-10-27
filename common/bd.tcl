namespace eval bd {

    # names the microblaze automation creates; kept in one place
    variable clk_wiz  clk_wiz_1
    variable rst_gen  rst_clk_wiz_1_100M
    variable mdm      mdm_1

    proc create {bd_name} {
        if {[llength [get_projects -quiet]] == 0} { error "bd::create needs an open project" }
        create_bd_design $bd_name
    }

    # connect an AXI slave pin to the cpu's peripheral port through the interconnect
    proc wire_axi {cpu slave_pin} {
        apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config \
          [list Clk_master "/$bd::clk_wiz/clk_out1 (100 MHz)" Clk_slave Auto \
                Clk_xbar "/$bd::clk_wiz/clk_out1 (100 MHz)" \
                Master "/$cpu (Periph)" Slave /$slave_pin \
                ddr_seg Auto intc_ip /${cpu}_axi_periph master_apm 0] \
          [get_bd_intf_pins $slave_pin]
    }

    # MicroBlaze + UART + external ports.
    # opts keys: cpu uart local_mem baud clk_port reset_port uart_port
    proc add_mb_system {opts} {
        dict with opts {}

        # ---- MicroBlaze ----
        create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze $cpu

        apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config \
          [list axi_intc 1 axi_periph Enabled cache None clk {New Clocking Wizard} \
                cores 1 debug_module {Debug Only} ecc None local_mem $local_mem \
                preset Microcontroller] \
          [get_bd_cells $cpu]

        puts "\n ALNs address space sanity check (want /$cpu/Data and /$cpu/Instruction): [get_bd_addr_spaces /$cpu/*] \n"

        # the automation adds an xlconcat we don't want; the UART interrupt goes straight to the intc
        delete_bd_objs [get_bd_nets ${cpu}_intr] [get_bd_cells ${cpu}_xlconcat]

        set_property CONFIG.PRIM_SOURCE Single_ended_clock_capable_pin [get_bd_cells $bd::clk_wiz]

        # debug module's system reset drives the clocking wizard reset
        connect_bd_net [get_bd_pins $bd::clk_wiz/reset] [get_bd_pins $bd::mdm/Debug_SYS_Rst]

        # ---- UART Lite ----
        create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite $uart
        set_property CONFIG.C_BAUDRATE $baud [get_bd_cells $uart]
        wire_axi $cpu $uart/S_AXI
        connect_bd_net [get_bd_pins $uart/interrupt] [get_bd_pins ${cpu}_axi_intc/intr]

        # ---- external ports ----
        # UART pins
        create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 $uart_port
        connect_bd_intf_net [get_bd_intf_ports $uart_port] [get_bd_intf_pins $uart/UART]

        # 100 MHz board clock into the clocking wizard
        create_bd_port -dir I -type clk -freq_hz 100000000 $clk_port
        connect_bd_net [get_bd_ports $clk_port] [get_bd_pins $bd::clk_wiz/clk_in1]

        # reset button, active low inside the block design
        create_bd_port -dir I -type rst $reset_port
        set_property CONFIG.POLARITY ACTIVE_LOW [get_bd_ports $reset_port]
        connect_bd_net [get_bd_ports $reset_port] [get_bd_pins $bd::rst_gen/ext_reset_in]

        puts "\n ALNs reset polarity sanity check (must be ACTIVE_LOW): [get_property CONFIG.POLARITY [get_bd_pins $bd::rst_gen/ext_reset_in]] \n"
    }

    # validate, save first, then generate output products
    proc finalize {bd_name} {
        validate_bd_design
        save_bd_design
        generate_target all [get_files ${bd_name}.bd]
    }
    # Instantiate a packaged AXI slave IP and wire it to the cpu's peripheral bus.
    proc add_axi_ip {cpu vlnv cell} {
        create_bd_cell -type ip -vlnv $vlnv $cell
        wire_axi $cpu $cell/AXI
    }

    # Export an interface pin of a cell as an external BD port.
    proc export_intf {pin port_name} {
        make_bd_intf_pins_external -name $port_name [get_bd_intf_pins $pin]
    }
}
