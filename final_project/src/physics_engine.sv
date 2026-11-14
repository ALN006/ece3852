/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */   
// TODO: There is a lot of documentation/diagrams that can and perhaps should accompany this code, figure out how to go about that 

// ASSUMPTION: paddles cant collide with each other
module physics_engine 
    import our_logic_types_pkg::*; // abandon the * import as soon as more than 1 package is ever used because it is a slipery slop
#(
    parameter int                                       MAX_SIMULTAENEOUS_KEYCODES                              = 6, 
    parameter int                                       KEYCODE_WIDTH                                           = 8,   
    parameter int                                       PADDLE_COUNT                                            = 2,
    parameter point_3d_t                                PADDLE_DIMS                                             = {COORD_WIDTH'(40), COORD_WIDTH'(60), COORD_WIDTH'(10)},
    parameter logic signed [ COORD_WIDTH   - 1 : 0 ]    BALL_RADIUS                                             = COORD_WIDTH'(20), 
    parameter logic signed [ 3*COORD_WIDTH - 1 : 0 ]    BALL_RESTART_LOCATION                                   = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}}),
    parameter logic signed [ 3*COORD_WIDTH - 1 : 0 ]    BALL_RESTART_VELOCITY                                   = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}}),
    parameter logic signed [ KEYCODE_WIDTH   - 1 : 0 ]  INPUT_KEYS  [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1 ]   = '{ default: (KEYCODE_WIDTH)'({(KEYCODE_WIDTH + 1)/2 {2'b10}})}
)(
    input   logic                                       clk,
    input   logic                                       reset,
    input   logic                                       calc_now,
    input   logic signed [ KEYCODE_WIDTH   - 1 : 0 ]    keycodes    [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1 ],
    
    // TODO: check if struct ports are supported by vivado
    output  sphere_t               ball,
    output  cuboid_t               paddles     [ 0 : PADDLE_COUNT                  - 1 ]
);
    assign ball.radius = BALL_RADIUS; // TODO: mixed driver on ball, check if this breaks vivado

    logic prev_calc_now;
    point_3d_t ball_velocity;
    always @( posedge clk ) begin 
        prev_calc_now <= calc_now;
        if (reset == 1'b1) begin 
            ball.center     <= BALL_RESTART_LOCATION;
            ball_velocity   <= BALL_RESTART_VELOCITY;
            // TODO: properly reset paddle locations
        end else begin 
            ball.center     <= (~calc_now & prev_calc_now) ? trunc_add(ball.center, ball_velocity) : ball.center;
            for (int i = 0; i < PADDLE_COUNT; i++) begin 
                // TODO: write collision logic: if collision change ball velocity accordingly 
            end
            // TODO: properly set paddle locations
        end
    end 

    // TODO: check if bellow code meets timing
    point_3d_t                              v_r_0       [ 0 : PADDLE_COUNT - 1 ];
    point_3d_t                              v_1_0       [ 0 : PADDLE_COUNT - 1 ];
    point_3d_t                              v_2_0       [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*COORD_WIDTH + 1 : 0 ]  d_r_0_1_0   [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*COORD_WIDTH + 1 : 0 ]  d_r_0_2_0   [ 0 : PADDLE_COUNT - 1 ];
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin 
        v_r_0[i]        = trunc_sub(ball.center,    paddles[i].v0);
        v_1_0[i]        = trunc_sub(paddles[i].v1,  paddles[i].v0);
        v_2_0[i]        = trunc_sub(paddles[i].v2,  paddles[i].v0);
        d_r_0_1_0[i]    = dot(v_r_0[i], v_1_0[i]);
        d_r_0_2_0[i]    = dot(v_r_0[i], v_2_0[i]);
    end
endmodule
