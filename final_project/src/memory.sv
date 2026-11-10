module memory (
    input logic clk,
    input logic [15:0] address,
    input logic enable,

    inout logic [31:0] data
);

    blk_mem_gen_0 sram0 (
        //AXI memory connection
        .addr	(address),
        .clk	(clk), .wea(enable),
        .din	(data),

        .dout	(data),
    );

endmodule