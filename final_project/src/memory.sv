/* verilator lint_off UNUSEDSIGNAL */ //TODO: actually implement this module, figure out if infered BRAMS are the way to go
module memory #(
    parameter int ADDRESS_WIDTH = 16,
    parameter int DATA_WIDTH    = 16
)(
    input   logic                               clk,
    input   logic [ ADDRESS_WIDTH   - 1 : 0 ]   address,
    input   logic                               enable,
    input   logic [ DATA_WIDTH      - 1 : 0 ]   write_data,

    output  logic [ DATA_WIDTH      - 1 : 0 ]   read_data

);
    always_ff @(posedge clk) begin 
        if (enable == 1'b0) begin 
            read_data <= { (DATA_WIDTH+1)/2 {2'b10} };
        end
    end
endmodule
