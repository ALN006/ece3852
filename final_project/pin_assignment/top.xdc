create_clock -period 10.000 -name clk_100 -waveform {0.000 5.000} [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS25 [get_ports reset_rtl_0]

set_property PACKAGE_PIN N15 [get_ports clk]
set_property PACKAGE_PIN J2 [get_ports reset_rtl_0]

#HDMI Signals
set_property -dict { PACKAGE_PIN V17   IOSTANDARD TMDS_33 } [get_ports {hdmi_tmds_clk_n}]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD TMDS_33 } [get_ports {hdmi_tmds_clk_p}]

set_property -dict { PACKAGE_PIN U18   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_tx_n[0]}]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_tx_n[1]}]
set_property -dict { PACKAGE_PIN T14   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_tx_n[2]}]
                                    
set_property -dict { PACKAGE_PIN U17   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_tx_p[0]}]
set_property -dict { PACKAGE_PIN R16   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_tx_p[1]}]
set_property -dict { PACKAGE_PIN R14   IOSTANDARD TMDS_33  } [get_ports {hdmi_tmds_tx_p[2]}]

# UART Signals (if we end up using printf)
# set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_rxd]
# set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_txd]
# set_property PACKAGE_PIN B16 [get_ports uart_rtl_0_rxd]
# set_property PACKAGE_PIN A16 [get_ports uart_rtl_0_txd]