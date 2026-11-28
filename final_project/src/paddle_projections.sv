import our_logic_pkg::*;

module paddle_projections #(
    parameter int PADDLE_COUNT    = 2,
    )(
    input logic clk, reset, frame_tick,

    input polar_coord_t paddles [0:PADDLE_COUNT-1],

    output cart_coord_t [7:0] paddles_2d [0:PADDLE_COUNT-1] // each paddle for projection made up of 8 cartesian coordinates
);
    // define the vertices, follows convention I wrote in my iPad

    dist_t [7:0] paddles_x [0:PADDLE_COUNT-1];
    dist_t [7:0] paddles_y [0:PADDLE_COUNT-1];

    always_comb begin
        for (int i = 0; i < PADDLE_COUNT; i++) begin
            paddles_2d[i][0] = polar_to_cart(paddles[i]);
            paddles_2d[i][1] = polar_to_cart({paddles[i].radius, paddles[i].phi, paddles[i].theta + PADDLE_THETA_OFFSET});
            paddles_2d[i][2] = polar_to_cart({paddles[i].radius, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta});
            paddles_2d[i][3] = polar_to_cart({paddles[i].radius, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta + PADDLE_THETA_OFFSET});
            paddles_2d[i][4] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi, paddles[i].theta});
            paddles_2d[i][5] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi, paddles[i].theta + PADDLE_THETA_OFFSET});
            paddles_2d[i][6] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta});
            paddles_2d[i][7] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta + PADDLE_THETA_OFFSET});
        end
    end

    generate // generate for loop structure inspired by the following: https://stackoverflow.com/questions/33899691/instantiate-modules-in-generate-for-loop-in-verilog
        for (genvar i = 0; i < PADDLE_COUNT; i++) begin : convex_hull_generation
            convex_hull calculate_convex_hulls (
                .clk,
                .rst_n(~reset),
                .start(frame_tick),
            );
        end
    endgenerate

endmodule