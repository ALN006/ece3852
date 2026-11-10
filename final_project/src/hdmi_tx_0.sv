module hdmi_tx_0 (

    input logic pix_clk, pix_clkx5, pix_clk_locked,
    input logic rst,
    input logic [3:0] red, green, blue,
    input logic hsync, vsync, vde,
    input logic aux0_din, aux1_din, aux2_din, ade,

    output logic TMDS_CLK_N, TMDS_CLK_P,
    output logic [2:0] TMDS_DATA_N, TMDS_DATA_P

);

    assign TMDS_CLK_N, TMDS_CLK_P = 1'b0;
    assign {TMDS_DATA_N, TMDS_DATA_P} = 6'h2A;

endmodule