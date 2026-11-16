/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */   
// TODO: There is a lot of documentation/diagrams that can and perhaps should accompany this code, figure out how to go about that 

// ASSUMPTION: paddles cant collide with each other
module physics_engine 
    import our_logic_types_pkg::*; // abandon the * import as soon as more than 1 package is ever used because it is a slipery slop
#(
    parameter int                                       KEYCODES_PER_PADDLE                                         = 3, 
    parameter int                                       KEYCODE_WIDTH                                               = 8,   
    parameter int                                       PADDLE_COUNT                                                = 2,
    parameter paddle_t                                  PADDLE_AT_RESTART                                           = {(2*ANGLE_WIDTH + DIST_WIDTH){2'b10}},
    parameter sphere_t                                  BALL_AT_RESTART                                             = {2*DIST_WIDTH {2'b10}},
    parameter logic signed [ 3*DIST_WIDTH - 1 : 0 ]     BALL_RESTART_VELOCITY                                       = (3*DIST_WIDTH)'({(3*DIST_WIDTH + 1)/2 {2'b10}}),
    parameter logic signed [ KEYCODE_WIDTH   - 1 : 0 ]  INPUT_KEYS  [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE    - 1 ] = '{ default: (KEYCODE_WIDTH)'({(KEYCODE_WIDTH + 1)/2 {2'b10}})}
)(
    input   logic                                       clk,
    input   logic                                       reset,
    input   logic                                       calc_now,
    input   logic signed [ KEYCODE_WIDTH   - 1 : 0 ]    keycodes    [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE    - 1 ],
    
    // TODO: check if struct ports are supported by vivado
    output  sphere_t               ball,
    output  paddle_t               paddles     [ 0 : PADDLE_COUNT                  - 1 ]
);

    logic prev_calc_now;
    point_3d_t ball_velocity;
    always @( posedge clk ) begin 
        prev_calc_now <= calc_now;
        if (reset == 1'b1) begin 
            ball            <= BALL_AT_RESTART;
            ball_velocity   <= BALL_RESTART_VELOCITY;
            for (int i = 0; i < PADDLE_COUNT; i++) paddles[i] <= PADDLE_AT_RESTART;
        end else begin 
            if (~calc_now & prev_calc_now) begin
                ball <= {trunc_add(ball.center, ball_velocity), ball.radius};
                for (int i = 0; i < PADDLE_COUNT; i++) begin 
                    paddles[i] <= {
                        {
                            (keycodes[KEYCODES_PER_PADDLE*i] == INPUT_KEYS[KEYCODES_PER_PADDLE*i ]) ? paddles[i].front_top_left.radius + DIST_WIDTH'(1), paddles[i].front_top_left.radius + DIST_WIDTH'(-1),
                            (keycodes[KEYCODES_PER_PADDLE*i + 1 ] == INPUT_KEYS[KEYCODES_PER_PADDLE*i + 1 ]) ? paddles[i].front_top_left.theta + ANGLE_WIDTH'(1), paddles[i].front_top_left.theta + ANGLE_WIDTH'(-1),
                            (keycodes[KEYCODES_PER_PADDLE*i + 2 ] == INPUT_KEYS[KEYCODES_PER_PADDLE*i + 2 ]) ? paddles[i].front_top_left.phi + ANGLE_WIDTH'(1), paddles[i].front_top_left.phi + ANGLE_WIDTH'(-1)
                        },
                        paddles[i].phi_offset, 
                        paddles[i].theta_offset, 
                        paddles[i].radius
                    };
                end
                // TODO: write collision logic: if collision change ball velocity accordingly 
            end
        end
    end 
endmodule
