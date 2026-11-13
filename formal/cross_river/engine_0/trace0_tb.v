`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  wire [0:0] PI_clk = clock;
  reg [0:0] PI_move_w;
  reg [0:0] PI_reset;
  reg [0:0] PI_move_g;
  reg [0:0] PI_move_c;
  cross_river UUT (
    .clk(PI_clk),
    .move_w(PI_move_w),
    .reset(PI_reset),
    .move_g(PI_move_g),
    .move_c(PI_move_c)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.$auto$async2sync.\cc:107:execute$86  = 1'b0;
    // UUT.$auto$async2sync.\cc:116:execute$90  = 1'b1;
    UUT.bank_c = 1'b0;
    UUT.bank_g = 1'b1;
    UUT.bank_m = 1'b1;
    UUT.bank_w = 1'b0;
    UUT.f_past_valid = 1'b0;

    // state 0
    PI_move_w = 1'b0;
    PI_reset = 1'b1;
    PI_move_g = 1'b0;
    PI_move_c = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b1;
      PI_move_c <= 1'b0;
    end

    // state 2
    if (cycle == 1) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b0;
      PI_move_c <= 1'b0;
    end

    // state 3
    if (cycle == 2) begin
      PI_move_w <= 1'b1;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b0;
      PI_move_c <= 1'b0;
    end

    // state 4
    if (cycle == 3) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b1;
      PI_move_c <= 1'b0;
    end

    // state 5
    if (cycle == 4) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b0;
      PI_move_c <= 1'b1;
    end

    // state 6
    if (cycle == 5) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b0;
      PI_move_c <= 1'b0;
    end

    // state 7
    if (cycle == 6) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b1;
      PI_move_c <= 1'b0;
    end

    // state 8
    if (cycle == 7) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b1;
      PI_move_c <= 1'b0;
    end

    // state 9
    if (cycle == 8) begin
      PI_move_w <= 1'b0;
      PI_reset <= 1'b0;
      PI_move_g <= 1'b0;
      PI_move_c <= 1'b0;
    end

    genclock <= cycle < 9;
    cycle <= cycle + 1;
  end
endmodule
