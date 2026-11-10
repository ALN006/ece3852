/* verilator lint_off UNUSEDSIGNAL */ // its fine this is just a shell to get a block diagram out of vivado for now
module memory #(
    parameter int ADDRESS_WIDTH = 16,
    parameter int DATA_WIDTH    = 16
)(
    input logic                             clk,
    input logic [ ADDRESS_WIDTH - 1 : 0 ]   address,
    input logic                             enable,
    input logic [ DATA_WIDTH - 1 : 0]       w_data,

    output logic [ DATA_WIDTH - 1 : 0]      r_data

);
    always_ff @(posedge clk) begin 
        if (enable == 1'b0) begin 
            r_data <= {(DATA_WIDTH+1)/2{2'b10}};
        end
    end
endmodule
