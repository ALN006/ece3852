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
    localparam int DIMENSIONS      = 3;
    localparam int COORD_WIDTH     = 11;
    localparam int RESULT_WIDTH    = 2*COORD_WIDTH + $clog2(DIMENSIONS);
	logic signed [ COORD_WIDTH - 1 : 0 ] vectors [ 0 : 1 ] [ 0 : DIMENSIONS - 1 ];
	logic signed [ RESULT_WIDTH - 1 : 0 ] dot_product;

    logic clk;
    initial begin // clock init
        clk = 1;
    end

    always begin 
        #1 clk = ~clk; // a clock cycle is 2 time units
    end

    dot_product_combinational #(
        .DIMENSIONS,
        .COORD_WIDTH
    ) dut(.*);

    initial begin
        $dumpfile("test_dot_product_combinational.vcd");
        $dumpvars(0, test_dot_product_combinational);

        @(posedge clk);
            vectors = '{ '{ '0, '0, '0 }, '{ '0, '0, '0 } };

        @(posedge clk);
            `check(dot_product, '0);
            vectors = '{ '{ COORD_WIDTH'(1),  COORD_WIDTH'(1), COORD_WIDTH'(1) }, '{ '0, '0, '0 } };

        @(posedge clk);
            `check(dot_product, '0);
            vectors = '{ '{ COORD_WIDTH'(1),  COORD_WIDTH'(1), COORD_WIDTH'(1) }, '{ COORD_WIDTH'(1),  COORD_WIDTH'(1), COORD_WIDTH'(1) } };

        @(posedge clk);
            `check(dot_product, RESULT_WIDTH'(3));
            vectors = '{ '{ COORD_WIDTH'(1), -COORD_WIDTH'(2), COORD_WIDTH'(3) }, '{ COORD_WIDTH'(4),  COORD_WIDTH'(5), -COORD_WIDTH'(6) } };

        @(posedge clk);
            `check(dot_product, RESULT_WIDTH'(-24));

        $display("done simulating dot_product_combinational");
        $finish();
    end
endmodule
