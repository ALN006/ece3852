# common/bd.tcl -- Block Design Construction & Peripheral Wiring Engine

namespace eval bd {

    proc build {proj_name} {
        cfg::init $proj_name
        util::step "Creating MicroBlaze Block Design for $proj_name"

        set bd_name "mb_block"
        create_bd_design $bd_name

        # 1. Primary Clocking Wizard (Board 100MHz input clock -> System 100MHz clock)
        set clk_wiz [create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1]
        set_property -dict [list \
            CONFIG.PRIM_IN_FREQ {100.000} \
            CONFIG.RESET_TYPE {ACTIVE_LOW} \
            CONFIG.RESET_PORT {resetn} \
        ] $clk_wiz

        # 2. Reset Controller (Active-Low reset)
        set rst_gen [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M]

        # 3. MicroBlaze Processor
        set mb [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0]

        # 4. Debug Module (MDM)
        set mdm [create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1]

        # 5. AXI UARTLite (Serial Communication / Printf output)
        set uart [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0]

        # 6. Custom HDMI Text Controller Core (Packaged IP)
        set hdmi_ip [create_bd_cell -type ip -vlnv xilinx.com:user:hdmi_text_controller:1.0 hdmi_text_controller_0]

        # Apply MicroBlaze BD Automation to construct Local Memory (128KB) & AXI Interconnect
        apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { \
            axi_intc {1} \
            axi_periph {Enabled} \
            cache {None} \
            clk {/clk_wiz_1/clk_out1 (100 MHz)} \
            debug_module {Debug Only} \
            ecc {None} \
            local_mem {128KB} \
            preset {None} \
        } $mb

        # Apply BD Automation for Clock & Reset connections on remaining IPs
        apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
            axi_periph {/microblaze_0_axi_periph} \
            clk {/clk_wiz_1/clk_out1 (100 MHz)} \
            intc_ip {/microblaze_0_axi_intc} \
            master {/microblaze_0 (Periph)} \
            slave_type {Lite} \
        } [get_bd_intf_pins axi_uartlite_0/S_AXI]

        apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { \
            axi_periph {/microblaze_0_axi_periph} \
            clk {/clk_wiz_1/clk_out1 (100 MHz)} \
            intc_ip {/microblaze_0_axi_intc} \
            master {/microblaze_0 (Periph)} \
            slave_type {Lite} \
        } [get_bd_intf_pins hdmi_text_controller_0/S_AXI]

        # Make External Ports (Board Clocks, Resets, UART, and HDMI)
        make_bd_pins_external [get_bd_pins clk_wiz_1/clk_in1] -name "clk_100MHz"
        make_bd_pins_external [get_bd_pins clk_wiz_1/resetn] -name "reset_rtl_0"
        make_bd_intf_pins_external [get_bd_intf_pins axi_uartlite_0/UART] -name "uart_rtl_0"
        make_bd_intf_pins_external [get_bd_intf_pins hdmi_text_controller_0/HDMI] -name "hdmi_0"

        # Validate and Save Block Design
        validate_bd_design
        save_bd_design
        puts "=== Block Design '$bd_name' Created and Validated Successfully ==="
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
