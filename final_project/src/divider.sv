module divider #(
    parameter int INPUT_WIDTH = 10
)(
    input logic signed [INPUT_WIDTH-1:0] dividend,
    input logic signed [INPUT_WIDTH-1:0] divisor,
    input logic clk,
    input logic req,
    input logic reset,
    output logic signed [INPUT_WIDTH-1:0] quotient,
    output logic done
);

    // 1 for positive, 0 for negative
    logic dividend_sign; 
    assign dividend_sign = ~dividend[INPUT_WIDTH-1];
    logic divisor_sign;
    assign divisor_sign = ~divisor[INPUT_WIDTH-1];

    always_ff @(posedge clk) begin
        if (divisor_sign) begin
            dividend -= divisor;
        end else begin
            dividend += divisor;
        end
        if (dividend > 0) begin
            done = 1'b0;
            if (dividend_sign ^ divisor_sign) begin  // quotient is positive if signs match, negative if not
                quotient += 1'd1;
            end else begin
                quotient -= 1'd1;
            end
        end else begin
            done = 1'b1;
        end
    end
endmodule