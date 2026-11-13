`define FORMAL
module busy_counter #(
    parameter logic [15:0] MAX_BUSY_TIME = 16'd42
) (
    input logic clk,
    input logic reset,
    input logic start,
    output logic busy
);
    logic [15:0] counter;
    always_ff @(posedge clk) begin 
        if (reset) counter <= 16'h0000;
        else if(start) counter <= MAX_BUSY_TIME - 16'd1;
        else if(counter != 16'd0) counter <= counter - 16'd1;
        else counter <= 16'd0;
    end

    assign busy = (counter != 0);

    `ifdef FORMAL 
        logic initialized = 1'b0;
        always @(posedge clk) initialized <= 1'b1;
        always begin
            if (!initialized) assume(reset == 1'b1);
            else assume(reset == 1'b0);
        end 

        logic [15:0] prev_count;
        logic prev_start;
        logic prev_reset;

        always @(posedge clk) begin 
            prev_count <= counter;
            prev_start <= start;
            prev_reset <= reset;
            assert (reset // nothing matters in reset
            || (prev_reset && (counter == 16'd0)) // reset works
            || prev_count == 0 // idle
            || prev_count == counter + 16'd1 // decrements on each clock if not idle
            || (prev_start && counter == MAX_BUSY_TIME - 16'd1) // starts correctly
            );
        end 
    `endif

endmodule
