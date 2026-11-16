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
    parameter paddle_t                                  PADDLE_AT_RESTART                                           = '{ default: '1},
    parameter sphere_t                                  BALL_AT_RESTART                                             = '{ default: '1},
    parameter cart_coord_t                              BALL_RESTART_VELOCITY                                       = '{ default: '1},
    parameter logic signed [ KEYCODE_WIDTH   - 1 : 0 ]  INPUT_KEYS  [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE    - 1 ] = '{ default: '1}
)(
    input   logic                                       clk,
    input   logic                                       reset,
    input   logic                                       calc_now,
    input   logic signed [ KEYCODE_WIDTH   - 1 : 0 ]    keycodes    [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE  - 1 ],
    
    output  sphere_t                                    ball,
    output  paddle_t                                    paddles     [ 0 : PADDLE_COUNT                      - 1 ]
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
                // TODO: strongly consider making this part its own module
                for (int i = 0; i < PADDLE_COUNT; i++) begin 
                    if (keycodes[KEYCODES_PER_PADDLE*i] == INPUT_KEYS[KEYCODES_PER_PADDLE*i ]) begin
                        paddles[i].v.radius <= paddles[i].v.radius + DIST_WIDTH'(1);
                    end else begin 
                        paddles[i].v.radius <= paddles[i].v.radius + DIST_WIDTH'(-1);
                    end

                    if (keycodes[KEYCODES_PER_PADDLE*i + 1 ] == INPUT_KEYS[KEYCODES_PER_PADDLE*i + 1 ]) begin 
                        paddles[i].v.theta <= paddles[i].v.theta + ANGLE_WIDTH'(1);
                    end else begin 
                        paddles[i].v.theta <= paddles[i].v.theta + ANGLE_WIDTH'(-1);
                    end

                    if (keycodes[KEYCODES_PER_PADDLE*i + 2 ] == INPUT_KEYS[KEYCODES_PER_PADDLE*i + 2 ]) begin 
                        paddles[i].v.phi <= paddles[i].v.phi + ANGLE_WIDTH'(1);
                    end else begin
                        paddles[i].v.phi + ANGLE_WIDTH'(-1)
                    end
                end
                // TODO: write collision logic: if collision change ball velocity accordingly 
                
            end
        end
    end

    // TODO: silo of everything bellow into its own module
    cart_coord_t                            v   [ 0 : PADDLE_COUNT - 1 ];

    cart_coord_t                            v1  [ 0 : PADDLE_COUNT - 1 ];
    polar_coord_t                           pv1 [ 0 : PADDLE_COUNT - 1 ];

    cart_coord_t                            v2  [ 0 : PADDLE_COUNT - 1 ];
    polar_coord_t                           pv2 [ 0 : PADDLE_COUNT - 1 ];

    cart_coord_t                            v3  [ 0 : PADDLE_COUNT - 1 ];
    polar_coord_t                           pv3 [ 0 : PADDLE_COUNT - 1 ];

    logic signed [ 2*DIST_WIDTH + 1 : 0 ]   d1  [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*DIST_WIDTH + 1 : 0 ]   d2  [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*DIST_WIDTH + 1 : 0 ]   d3  [ 0 : PADDLE_COUNT - 1 ];
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin
        pv1[i].radius   = paddles[i].v.radius + paddles[i].depth;
        pv1[i].theta    = paddles[i].v.theta;
        pv1[i].phi      = paddles[i].v.phi;
        
        pv2[i].radius   = paddles[i].v.radius;
        pv2[i].theta    = paddles[i].v.theta + paddles[i].theta_offset;
        pv2[i].phi      = paddles[i].v.phi;

        pv3[i].radius   = paddles[i].v.radius;
        pv3[i].theta    = paddles[i].v.theta;
        pv3[i].phi      = paddles[i].v.phi + paddles[i].phi_offset;

        v[i]    = polar_to_cart(paddles[i].v);
        v1[i]   = polar_to_cart(pv1[i]);
        v2[i]   = polar_to_cart(pv2[i]);
        v2[i]   = polar_to_cart(pv3[i]);

        d1[i] =  dot(trunc_sub(v1, v), trunc_sub(ball.center, v));
        d2[i] =  dot(trunc_sub(v2, v), trunc_sub(ball.center, v));
        d3[i] =  dot(trunc_sub(v3, v), trunc_sub(ball.center, v));
    end
endmodule
