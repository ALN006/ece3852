// Reference: https://www.geeksforgeeks.org/dsa/find-input_number-root-of-a-number-using-bit-manipulation/
module sqrt
    #(  parameter   int                         INPUT_WIDTH     = 32,
        localparam  int                         SOLUTION_WIDTH  = (INPUT_WIDTH+1)/2 )(
        input       logic [INPUT_WIDTH-1:0]     input_number,
        input       logic                       clk,
        input       logic                       req,
        input       logic                       reset,
        output      logic                       done,
        output      logic [SOLUTION_WIDTH-1:0]  result
    );
    logic [ SOLUTION_WIDTH - 1 : 0 ] in_consideration; 
    assign in_consideration = result | current_bit;

    logic [ SOLUTION_WIDTH - 1 : 0 ] current_bit; 
    always_ff @(posedge clk) begin
        if (reset == 1'b1) begin 
            {current_bit} <='0;
            {done} <= '1;
        end else begin
            if (done == 1'b1) begin 
                if ( req == 1'b1 ) begin
                    current_bit[SOLUTION_WIDTH - 1] <= 1'b1;
                    {result, done} <= '0;
                end else begin
                    done <= done;
                    result <= result;
                    current_bit <= current_bit;
                end
            end else begin 
                current_bit <= { 1'b0, current_bit[ SOLUTION_WIDTH - 1 : 1 ]};
                if (in_consideration * in_consideration > input_number) begin
                    result <= result;
                end else begin
                    result <= in_consideration;
                end
                if (current_bit[0] == 1'b1) begin
                    done <= 1'b1;
                end else begin 
                    done <= done;
                end
            end
        end
    end

	`ifdef FORMAL // TODO: come back and write this properly later
		always @(*) assert(result == $sqrt(input_number));
	`endif
endmodule
