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
                TMDS_CLK_P  hdmi_clk_p \
                TMDS_CLK_N  hdmi_clk_n \
                TMDS_DATA_P hdmi_tx_p \
                TMDS_DATA_N hdmi_tx_n \
            ] \
        ] \
    ] \
]
