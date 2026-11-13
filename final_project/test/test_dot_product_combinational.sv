/* verilator lint_off UNUSEDSIGNAL */
`include "final_project/src/dot_product_combinational.sv"
`define check(signal, value) \
    assert ((signal) == (value)) else \
        $error("%s Fail -> Expected: %h, Found: %h", `"signal`", (value), (signal));

timeunit 10ns;
timeprecision 1ns;

module test_dot_product_combinational;
// :)  parameter int DIMENSIONS = 3;
	// NOTE: must always be atleast 2;
	// TODO: consider enforcing this NOTE with an assertion parameter int COORD_WIDTH = 10 localparam int RESULT_WDITH = 2*COORD_WIDTH + $clog2(DIMENSIONS) ) (;
	logic signed [ COORD_WIDTH - 1 : 0 ] vectors [ 0 : 1 ] [ 0 : DIMENSIONS ];
	logic signed [ RESULT_WDITH - 1 : 0 ] dot_product;

    initial begin // clock init
        clk = 1;
    end

    always begin 
        #1 clk = ~clk; // a clock cycle is 2 time units
    end

    dot_product_combinational dut(.*);

    initial begin
        $dumpfile("test_dot_product_combinational.vcd");
        $dumpvars(0, test_dot_product_combinational);

        @(posedge clk);
            // Testbench logic

        $display("done simulating dot_product_combinational");
        $finish();
    end

endmodule
