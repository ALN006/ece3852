// Source: https://www.geeksforgeeks.org/dsa/find-square-root-of-a-number-using-bit-manipulation/

module sqrt#(
    parameter int COORD_BITS = 32,
    localparam int SOLUTION_BITS = (COORD_BITS+1)/2
)(
    input logic [COORD_BITS-1:0] square,
    output logic [SOLUTION_BITS-1:0] result
);

always_comb begin // implements a set of cascading muxes, small enough to be fine

    result = '0;
//                                      '{{{11{ir[4]}},ir[4:0]}
    for (integer i = SOLUTION_BITS-1; i >= 0; i--) begin
        if ((2**i + result)**2 > square) begin
            result = result;
        end else begin
            result = result + 2**i;
        end
    end
end


endmodule