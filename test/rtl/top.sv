module top(
	input logic a,
	input logic b,

	output logic c
);
	assign c = b & a;
endmodule
