import our_logic_pkg::*;

module paddle_projections #(
    parameter int PADDLE_COUNT    = 2,
    )(
    input polar_coord_t paddles [0:PADDLE_COUNT-1],

    output cart_coord_t [7:0] paddles_2d [0:PADDLE_COUNT-1] // each paddle for projection made up of 8 cartesian coordinates
);

    // define the vertices, follows convention I wrote in my iPad
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin
        paddles_2d[i][0] = polar_to_cart(paddles[i]);
        paddles_2d[i][1] = polar_to_cart({paddles[i].radius, paddles[i].phi, paddles[i].theta + PADDLE_THETA_OFFSET});
        paddles_2d[i][2] = polar_to_cart({paddles[i].radius, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta});
        paddles_2d[i][3] = polar_to_cart({paddles[i].radius, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta + PADDLE_THETA_OFFSET});
        paddles_2d[i][4] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi, paddles[i].theta});
        paddles_2d[i][5] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi, paddles[i].theta + PADDLE_THETA_OFFSET});
        paddles_2d[i][6] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta});
        paddles_2d[i][7] = polar_to_cart({paddles[i].radius + PADDLE_RADIUS_OFFSET, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta + PADDLE_THETA_OFFSET});
    end

endmodule