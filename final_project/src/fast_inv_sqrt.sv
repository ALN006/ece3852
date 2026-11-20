//-----------------------------------------------------------------------------
// fast_inv_sqrt_fixed.sv
//
// Fixed-point / integer wrapper around fast_inv_sqrt (see fast_inv_sqrt.sv).
//
//   in_u  : unsigned, IN_W bits (<= 32), with IN_FRAC fractional bits
//           real value = in_u / 2^IN_FRAC
//   out_u : unsigned, OUT_W bits (<= 32), with OUT_FRAC fractional bits
//           real value = out_u / 2^OUT_FRAC  ~=  1/sqrt(in value)
//
// Latency: NUM_ITER + 3 cycles (input convert, core, output convert).
// Throughput: one result per cycle, no backpressure.
// Compile fast_inv_sqrt.sv first (it defines fisqrt_pkg and fast_inv_sqrt).
//-----------------------------------------------------------------------------
 
// Unsigned fixed-point -> IEEE-754 single (truncating). Zero maps to +0.
module uint_to_fp32 #(
  parameter int W    = 32,   // must be <= 32
  parameter int FRAC = 0
) (
  input  logic [W-1:0] u,
  output logic [31:0]  f
);
  localparam int PAD = 32 - W;
 
  logic [31:0] ext, norm;
  int          lead;
  int          e;
 
  always_comb begin
    ext  = 32'(u) << PAD;               // left-align into 32 bits
    lead = 0;
    for (int k = 0; k < 32; k++)
      if (ext[k]) lead = k;             // index of highest set bit
 
    norm = ext << (31 - lead);          // leading one now at bit 31
    e    = 127 + (lead - PAD) - FRAC;   // biased exponent
 
    if (ext == 32'd0 || e <= 0) f = 32'd0;
    else if (e >= 255)          f = 32'h7F800000;
    else                        f = {1'b0, e[7:0], norm[30:8]};
  end
endmodule
 
 
// IEEE-754 single (positive) -> unsigned fixed-point, saturating.
// Negative, zero/denormal -> 0.  Inf/NaN/overflow -> all ones.
module fp32_to_ufixed #(
  parameter int OUT_W    = 32,        // must be <= 32
  parameter int OUT_FRAC = 16
) (
  input  logic [31:0]      f,
  output logic [OUT_W-1:0] y
);
  logic [63:0] m24, wide;
  int          e, sh;
 
  always_comb begin
    e    = int'(f[30:23]);
    m24  = {40'd0, 1'b1, f[22:0]};
    sh   = e - 127 + OUT_FRAC - 23;     // net shift applied to the 24-bit mantissa
    wide = 64'd0;
    y    = '0;
 
    if (f[31] || e == 0) begin
      y = '0;
    end else if (e == 255 || sh >= 40) begin
      y = '1;
    end else begin
      if (sh >= 0)       wide = m24 << sh;
      else if (sh > -64) wide = m24 >> (-sh);
      else               wide = 64'd0;
 
      if ((wide >> OUT_W) != 64'd0) y = '1;
      else                          y = wide[OUT_W-1:0];
    end
  end
endmodule
 
 
module fast_inv_sqrt #(
  parameter int IN_W     = 32,
  parameter int IN_FRAC  = 0,
  parameter int OUT_W    = 32,
  parameter int OUT_FRAC = 16,
  parameter int NUM_ITER = 2
) (
  input  logic             clk,
  input  logic             rst_n,
 
  input  logic             in_valid,
  input  logic [IN_W-1:0]  in_u,
 
  output logic             out_valid,
  output logic [OUT_W-1:0] out_u
);
 
  // ---- Stage A: integer -> float, registered ----
  logic [31:0] fp_in_comb, fp_in_q;
  logic        v_in_q;
 
  uint_to_fp32 #(.W(IN_W), .FRAC(IN_FRAC)) u_i2f (.u(in_u), .f(fp_in_comb));
 
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      fp_in_q <= '0;
      v_in_q  <= 1'b0;
    end else begin
      fp_in_q <= fp_in_comb;
      v_in_q  <= in_valid;
    end
  end
 
  // ---- Core ----
  logic [31:0] fp_out;
  logic        core_valid;
 
  fast_inv_sqrt #(.NUM_ITER(NUM_ITER)) u_core (
    .clk       (clk),
    .rst_n     (rst_n),
    .in_valid  (v_in_q),
    .in_x      (fp_in_q),
    .out_valid (core_valid),
    .out_y     (fp_out)
  );
 
  // ---- Stage C: float -> fixed, registered ----
  logic [OUT_W-1:0] fx_comb;
 
  fp32_to_ufixed #(.OUT_W(OUT_W), .OUT_FRAC(OUT_FRAC)) u_f2i (.f(fp_out), .y(fx_comb));
 
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      out_u     <= '0;
      out_valid <= 1'b0;
    end else begin
      out_u     <= fx_comb;
      out_valid <= core_valid;
    end
  end
 
endmodule
 