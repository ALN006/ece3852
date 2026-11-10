module clk_wiz_0 (

    input logic reset,
    input logic clk_in1,

    output logic locked,
    output logic clk_out_1, clk_out_2

);

    assign locked = 1'b1;
    assign clk_out_1 = 1'b0;
    assign clk_out_2 = 1'b1;

endmodule