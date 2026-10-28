<<<<<<< HEAD
set ip_spec [dict create \
    name         hdmi_text_controller \
    version      1.0 \
    revision     1 \
    vendor       xilinx.com \
    library      user \
    top          hdmi_text_controller_v1_0 \
    nested       [dict create \
        clk_wiz_0 [dict create \
            vlnv   "xilinx.com:ip:clk_wiz:6.0" \
            config [list CONFIG.PRIM_SOURCE Single_ended_clock_capable_pin \
                         CONFIG.CLKOUT1_REQUESTED_OUT_FREQ 25.175] \
        ] \
        hdmi_tx_0 [dict create \
            vlnv   "realdigital.com:realdigital:hdmi_tx:1.0" \
        ] \
    ] \
    interfaces   [dict create \
        AXI [dict create \
            abstraction xilinx.com:interface:aximm_rtl:1.0 \
            bus_type    xilinx.com:interface:aximm:1.0 \
            mode        slave \
            description "AXI4-Lite Slave Interface" \
            map         [list \
                S_AXI_ACLK    s_axi_aclk \
                S_AXI_ARESETN s_axi_aresetn \
                S_AXI_AWADDR  s_axi_awaddr \
                S_AXI_AWPROT  s_axi_awprot \
                S_AXI_AWVALID s_axi_awvalid \
                S_AXI_AWREADY s_axi_awready \
                S_AXI_WDATA   s_axi_wdata \
                S_AXI_WSTRB   s_axi_wstrb \
                S_AXI_WVALID  s_axi_wvalid \
                S_AXI_WREADY  s_axi_wready \
                S_AXI_BRESP   s_axi_bresp \
                S_AXI_BVALID  s_axi_bvalid \
                S_AXI_BREADY  s_axi_bready \
                S_AXI_ARADDR  s_axi_araddr \
                S_AXI_ARPROT  s_axi_arprot \
                S_AXI_ARVALID s_axi_arvalid \
                S_AXI_ARREADY s_axi_arready \
                S_AXI_RDATA   s_axi_rdata \
                S_AXI_RRESP   s_axi_rresp \
                S_AXI_RVALID  s_axi_rvalid \
                S_AXI_RREADY  s_axi_rready \
            ] \
        ] \
        HDMI [dict create \
            abstraction xilinx.com:interface:hdmi_rtl:1.0 \
            bus_type    xilinx.com:interface:hdmi:1.0 \
            mode        master \
            description "HDMI Output Interface" \
            map         [list \
=======
# lab7/ip/hdmi_text_controller/ip_spec.tcl -- Manifest for HDMI Text Controller Core

set ip_spec [dict create \
    name       "hdmi_text_controller" \
    version    "1.0" \
    revision   1 \
    vendor     "xilinx.com" \
    library    "user" \
    top        "hdmi_text_controller_v1_0" \
    nested     [dict create \
        clk_wiz_0 [dict create \
            vlnv "xilinx.com:ip:clk_wiz:6.0" \
            config [list \
                CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {25.175} \
                CONFIG.MMCM_CLKOUT0_DIVIDE_F {39.625} \
                CONFIG.USE_LOCKED {false} \
                CONFIG.USE_RESET {false} \
            ] \
        ] \
        hdmi_tx_0 [dict create \
            vlnv "realdigital.com:realdigital:hdmi_tx:1.0" \
        ] \
    ] \
    interfaces [dict create \
        HDMI [dict create \
            abstraction "xilinx.com:interface:hdmi_rtl:1.0" \
            bus_type    "xilinx.com:interface:hdmi:1.0" \
            mode        "master" \
            description "HDMI output interface" \
            map [list \
>>>>>>> 66d377739bf221820e7840e29bfaf5dfbb36fa2b
                TMDS_CLK_P  hdmi_clk_p \
                TMDS_CLK_N  hdmi_clk_n \
                TMDS_DATA_P hdmi_tx_p \
                TMDS_DATA_N hdmi_tx_n \
            ] \
        ] \
    ] \
]
<<<<<<< HEAD

=======
>>>>>>> 66d377739bf221820e7840e29bfaf5dfbb36fa2b
