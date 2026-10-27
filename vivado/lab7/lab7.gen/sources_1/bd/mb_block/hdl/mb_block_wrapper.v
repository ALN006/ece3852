//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2023.1 (lin64) Build 3865809 Sun May  7 15:04:56 MDT 2023
//Date        : Mon Oct 26 22:32:29 2026
//Host        : linux-ssh-04.ews.illinois.edu running 64-bit Red Hat Enterprise Linux 9.8 (Plow)
//Command     : generate_target mb_block_wrapper.bd
//Design      : mb_block_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module mb_block_wrapper
   (clk_100MHz,
    hdmi_tmds_clk_n,
    hdmi_tmds_clk_p,
    hdmi_tmds_data_n,
    hdmi_tmds_data_p,
    reset_rtl_0,
    uart_rtl_0_rxd,
    uart_rtl_0_txd);
  input clk_100MHz;
  output hdmi_tmds_clk_n;
  output hdmi_tmds_clk_p;
  output [2:0]hdmi_tmds_data_n;
  output [2:0]hdmi_tmds_data_p;
  input reset_rtl_0;
  input uart_rtl_0_rxd;
  output uart_rtl_0_txd;

  wire clk_100MHz;
  wire hdmi_tmds_clk_n;
  wire hdmi_tmds_clk_p;
  wire [2:0]hdmi_tmds_data_n;
  wire [2:0]hdmi_tmds_data_p;
  wire reset_rtl_0;
  wire uart_rtl_0_rxd;
  wire uart_rtl_0_txd;

  mb_block mb_block_i
       (.clk_100MHz(clk_100MHz),
        .hdmi_tmds_clk_n(hdmi_tmds_clk_n),
        .hdmi_tmds_clk_p(hdmi_tmds_clk_p),
        .hdmi_tmds_data_n(hdmi_tmds_data_n),
        .hdmi_tmds_data_p(hdmi_tmds_data_p),
        .reset_rtl_0(reset_rtl_0),
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd));
endmodule
