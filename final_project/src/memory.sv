// TODO: consider adding an assertion to prevent WORD_COUNT < 2
// TODO: check if $clog2 will ceil or floor or even deliver an integer 
module memory #(
    parameter int DATA_WIDTH    = 16,
    parameter int WORD_COUNT    = 128   // NOTE: WORD_COUNT must be greater than 1 and probably has no buisness being less than 128, or not being a power of 2
)(
    input   logic                                   clk,
    input   logic [ $clog2(WORD_COUNT)  - 1 : 0 ]   read_address, write_address,
    input   logic                                   enable,
    input   logic [ DATA_WIDTH          - 1 : 0 ]   write_data,

    output  logic [ DATA_WIDTH          - 1 : 0 ]   read_data

);
    logic [ DATA_WIDTH - 1 : 0 ] mem [ 0 : WORD_COUNT - 1 ];
    always_ff @(posedge clk) begin 
        if (enable == 1'b1) mem[write_address] <= write_data;
        read_data <= mem[read_address];
    end
endmodule
