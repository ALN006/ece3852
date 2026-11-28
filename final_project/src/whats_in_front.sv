import geometry_pkg::*;

module whats_in_front #(
    parameter int PADDLE_COUNT = 2;
    )(
    input dist_t drawX, drawY,
    input polar_coord_t paddles [0:PADDLE_COUNT-1],
    input cart_coord_t [7:0] paddles_2d [0:PADDLE_COUNT-1],
    input sphere_t ball,

    output logic ball_in_front, paddle0_in_front, paddle1_in_front
);

    logic consider_ball, consider_paddle0, consider_paddle1;
    always_comb begin
        if ((drawX-ball.center.x)**2 + (drawY-ball.center.y)**2 <= (ball.radius)**2) begin
            consider_ball = 1'b1;
        end else begin
            consider_ball = 1'b0;
        end
    end

endmodule