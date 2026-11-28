// DISCLAIMER: This file was generated almost entirely by Claude

// -----------------------------------------------------------------------------
// convex_hull
//
// Computes the convex hull of 8 arbitrary signed 2-D integer points using a
// gift-wrapping (Jarvis march) FSM. One hull vertex is emitted per clock.
//
//  * Output hull is counter-clockwise, starting at the left-most (then lowest)
//    point.
//  * Only strict vertices are reported: points collinear along a hull edge are
//    excluded, and duplicate points are collapsed.
//  * Degenerate inputs: all points identical -> count = 1;
//    all points collinear -> count = 2 (the two extreme points).
//  * Latency: 1 (latch) + hull_count cycles.
//
// Handshake: pulse `start` while !busy. Inputs are latched on that cycle.
// `done` pulses for one cycle when results are valid; hull_* and hull_count
// then hold until the next start.
// -----------------------------------------------------------------------------
import geometry_pkg::*;

module convex_hull #(
    parameter int DIST_WIDTH = 10                       // coordinate width (signed)
) (
    input  logic                 clk,
    input  logic                 rst_n,
 
    input  logic                 start,
    input  logic signed [DIST_WIDTH-1:0]  px [8],
    input  logic signed [DIST_WIDTH-1:0]  py [8],
 
    output logic                 busy,
    output logic                 done,
    output logic [3:0]           hull_count,   // 1..8
    output logic signed [DIST_WIDTH-1:0]  hull_x   [8], // valid for index < hull_count
    output logic signed [DIST_WIDTH-1:0]  hull_y   [8],
    output logic [2:0]           hull_idx [8]  // index of the original input point
);
 
    // Widths: differences need W+1 bits, products 2W+2, cross product 2W+3.
    localparam int CW = 2*DIST_WIDTH + 3;
 
    typedef enum logic [1:0] {S_IDLE, S_RUN} state_t;
    state_t state;
 
    logic signed [DIST_WIDTH-1:0] x_q [8];
    logic signed [DIST_WIDTH-1:0] y_q [8];
 
    logic [2:0] start_idx;   // combinational: left-most / lowest point
    logic [2:0] cur_idx;     // current hull vertex
    logic [2:0] next_idx;    // combinational: next CCW hull vertex
    logic       found_next;  // a point distinct from cur exists
    logic       wrap;        // next vertex is the start point -> finished
 
    // ------------------------------------------------------------------
    // Start point: minimum x, ties broken by minimum y (guaranteed hull vertex)
    // ------------------------------------------------------------------
    always_comb begin
        start_idx = 3'd0;
        for (int i = 1; i < 8; i++) begin
            if (x_q[i] < x_q[start_idx] ||
               (x_q[i] == x_q[start_idx] && y_q[i] < y_q[start_idx]))
                start_idx = 3'(i);
        end
    end
 
    // ------------------------------------------------------------------
    // Next hull vertex from cur_idx: the point such that every other point
    // lies to its left (cross >= 0). Collinear ties take the farthest point.
    // ------------------------------------------------------------------
    always_comb begin
        logic signed [DIST_WIDTH:0]    dxj, dyj, dxn, dyn;
        logic signed [CW-1:0] cross, dist_j, dist_n;
 
        next_idx   = cur_idx;
        found_next = 1'b0;
        cross = '0; dist_j = '0; dist_n = '0;
        dxj = '0; dyj = '0; dxn = '0; dyn = '0;
 
        for (int j = 0; j < 8; j++) begin
            dxj = (DIST_WIDTH+1)'(x_q[j]) - (DIST_WIDTH+1)'(x_q[cur_idx]);
            dyj = (DIST_WIDTH+1)'(y_q[j]) - (DIST_WIDTH+1)'(y_q[cur_idx]);
 
            if (dxj != 0 || dyj != 0) begin           // skip cur and duplicates of it
                if (!found_next) begin
                    next_idx   = 3'(j);
                    found_next = 1'b1;
                end else begin
                    dxn = (DIST_WIDTH+1)'(x_q[next_idx]) - (DIST_WIDTH+1)'(x_q[cur_idx]);
                    dyn = (DIST_WIDTH+1)'(y_q[next_idx]) - (DIST_WIDTH+1)'(y_q[cur_idx]);
 
                    cross  = CW'(dxn) * CW'(dyj) - CW'(dyn) * CW'(dxj);
                    dist_j = CW'(dxj) * CW'(dxj) + CW'(dyj) * CW'(dyj);
                    dist_n = CW'(dxn) * CW'(dxn) + CW'(dyn) * CW'(dyn);
 
                    // j is clockwise of current candidate -> it is more extreme
                    if (cross < 0 || (cross == 0 && dist_j > dist_n))
                        next_idx = 3'(j);
                end
            end
        end
    end
 
    // Finished when no distinct point exists or we wrap back to the start
    // (compare coordinates so duplicates of the start point also terminate).
    assign wrap = !found_next ||
                  (x_q[next_idx] == x_q[start_idx] &&
                   y_q[next_idx] == y_q[start_idx]);
 
    // ------------------------------------------------------------------
    // Control FSM: emit one vertex per cycle
    // ------------------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= S_IDLE;
            busy       <= 1'b0;
            done       <= 1'b0;
            hull_count <= '0;
            cur_idx    <= '0;
            for (int i = 0; i < 8; i++) begin
                x_q[i]      <= '0;
                y_q[i]      <= '0;
                hull_x[i]   <= '0;
                hull_y[i]   <= '0;
                hull_idx[i] <= '0;
            end
        end else begin
            done <= 1'b0;
 
            case (state)
                S_IDLE: begin
                    if (start) begin
                        for (int i = 0; i < 8; i++) begin
                            x_q[i] <= px[i];
                            y_q[i] <= py[i];
                        end
                        hull_count <= '0;
                        busy       <= 1'b1;
                        state      <= S_RUN;
                        cur_idx    <= 3'd0;   // fixed up on first RUN cycle
                    end
                end
 
                S_RUN: begin
                    if (hull_count == 0) begin
                        // First cycle: seed with the start point.
                        // (cur_idx must equal start_idx before searching.)
                        cur_idx <= start_idx;
                        // Record start vertex now, search next cycle.
                        hull_x[0]   <= x_q[start_idx];
                        hull_y[0]   <= y_q[start_idx];
                        hull_idx[0] <= start_idx;
                        hull_count  <= 4'd1;
                    end else begin
                        // cur_idx is already recorded; find its successor.
                        if (wrap || hull_count == 4'd8) begin
                            busy  <= 1'b0;
                            done  <= 1'b1;
                            state <= S_IDLE;
                        end else begin
                            hull_x[hull_count[2:0]]   <= x_q[next_idx];
                            hull_y[hull_count[2:0]]   <= y_q[next_idx];
                            hull_idx[hull_count[2:0]] <= next_idx;
                            hull_count                <= hull_count + 4'd1;
                            cur_idx                   <= next_idx;
                        end
                    end
                end
 
                default: state <= S_IDLE;
            endcase
        end
    end
 
endmodule