/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */   
// TODO: There is a lot of documentation/diagrams that can and perhaps should accompany this code, figure out how to go about that 

// ASSUMPTION: paddles cant collide with each other, if they are meant to then they will pass through each other
module physics_engine 
    import our_logic_pkg::*; // abandon the * import as soon as more than 1 package is ever used because it is a slipery slop
    #(  parameter int                                       KEYCODES_PER_PADDLE                                         = 3, 
        parameter int                                       KEYCODE_WIDTH                                               = 8,   
        parameter int                                       PADDLE_COUNT                                                = 2,
        parameter polar_coord_t                             PADDLE_AT_RESTART                                           = '{ default: '1},
        parameter sphere_t                                  BALL_AT_RESTART                                             = '{ default: '1},
        parameter cart_coord_t                              BALL_RESTART_VELOCITY                                       = '{ default: '1},
        parameter logic signed [ KEYCODE_WIDTH   - 1 : 0 ]  INPUT_KEYS  [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE    - 1 ] = '{ default: '1}  )(
        input   logic                                       clk,
        input   logic                                       reset,
        input   logic                                       calc_now,
        input   logic signed [ KEYCODE_WIDTH   - 1 : 0 ]    keycodes    [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE  - 1 ],
        output  sphere_t                                    ball,
        output  polar_coord_t                               paddles     [ 0 : PADDLE_COUNT                      - 1 ]
    );
    logic prev_calc_now;
    cart_coord_t ball_velocity;
    always @( posedge clk ) begin 
        prev_calc_now <= calc_now;
        if (reset == 1'b1) begin 
            ball            <= BALL_AT_RESTART;
            ball_velocity   <= BALL_RESTART_VELOCITY;
            for (int i = 0; i < PADDLE_COUNT; i++) paddles[i] <= PADDLE_AT_RESTART;
        end else begin 
            if (~calc_now & prev_calc_now) begin
                ball.center <= trunc_add(ball.center, ball_velocity);
                ball_velocity <= next_ball_velocity;
                // TODO: strongly consider making this part its own module, i dont imagine this will work rn, go to OH about what to do for this
                for (int i = 0; i < PADDLE_COUNT; i++) begin 
                    if (keycodes[KEYCODES_PER_PADDLE*i] == INPUT_KEYS[KEYCODES_PER_PADDLE*i ]) begin
                        paddles[i].radius <= paddles[i].radius + DIST_WIDTH'(1);
                    end else begin 
                        paddles[i].radius <= paddles[i].radius + DIST_WIDTH'(-1);
                    end

                    if (keycodes[KEYCODES_PER_PADDLE*i + 1 ] == INPUT_KEYS[KEYCODES_PER_PADDLE*i + 1 ]) begin 
                        paddles[i].theta <= paddles[i].theta + ANGLE_WIDTH'(1);
                    end else begin 
                        paddles[i].theta <= paddles[i].theta + ANGLE_WIDTH'(-1);
                    end

                    if (keycodes[KEYCODES_PER_PADDLE*i + 2 ] == INPUT_KEYS[KEYCODES_PER_PADDLE*i + 2 ]) begin 
                        paddles[i].phi <= paddles[i].phi + ANGLE_WIDTH'(1);
                    end else begin
                        paddles[i].phi <= paddles[i].phi + ANGLE_WIDTH'(-1);
                    end
                end
            end
        end
    end
    cart_coord_t    next_ball_velocity;
    collision_handler #(
        .PADDLE_COUNT(PADDLE_COUNT)
    ) ball_paddle_collision_handler (
        .paddles,
        .ball,
        .current_ball_velocity(ball_velocity),

        .next_ball_velocity
    );
endmodule
