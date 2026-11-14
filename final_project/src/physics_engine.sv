/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */   
// TODO: There is a lot of documentation/diagrams that can and perhaps should accompany this code, figure out how to go about that 
// TODO: The next thing to figure out for this guy is probably a colision detection mechanism which I imagine will involve calculating the distance between a point and some planes :)

//import our_logic_types_pkg::*; // TODO: integrate constants_pkg and types_pkg and abandon the * import as soon as more than 1 package is ever used because it is a slipery slop

module physics_engine 
    import our_logic_types_pkg::*;
#(
    parameter int                                       MAX_SIMULTAENEOUS_KEYCODES  = 6, 
    parameter int                                       KEYCODE_WIDTH               = 8,   
    parameter int                                       PADDLE_COUNT                = 2,
    parameter logic signed [ COORD_WIDTH   - 1 : 0 ]    PADDLE_HEIGHT               = COORD_WIDTH'(40),
    parameter logic signed [ COORD_WIDTH   - 1 : 0 ]    BALL_RADIUS                 = COORD_WIDTH'(20), 
    parameter logic signed [ 3*COORD_WIDTH - 1 : 0 ]    BALL_RESTART_LOCATION       = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}}),
    parameter logic signed [ 3*COORD_WIDTH - 1 : 0 ]    BALL_RESTART_VELOCITY       = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}})
)(
    input   logic signed                                clk,
    input   logic signed                                reset,
    input   logic signed                                calc_now,
    input   logic signed [ KEYCODE_WIDTH   - 1 : 0 ]    keycodes    [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1 ],
    
    // TODO: check if vivado supports syruct ports
    output  sphere_t               ball,
    output  cuboid_t               paddles     [ 0 : PADDLE_COUNT                  - 1 ]
);
    assign ball.radius = BALL_RADIUS;

    point_3d_t ball_velocity;
    always @( posedge clk ) begin 
        if (reset == 1'b1) begin 
            ball.center     <= BALL_RESTART_LOCATION;
            ball_velocity   <= BALL_RESTART_VELOCITY;
        end else begin 
            // TODO: this is definately ridiculous speed, consider fixing it
            ball.center     <= trunc_add(ball.center, ball_velocity);
            ball_velocity    <= ball_velocity;
        end
    end 

    // TODO: write an offset module to avoid repetition here
    point_3d_t                              ball_center_offset                  [ 0 : PADDLE_COUNT - 1 ];
    point_3d_t                              depth_vector                        [ 0 : PADDLE_COUNT - 1 ];
    point_3d_t                              width_vector                        [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*COORD_WIDTH + 1 : 0 ]  ball_center_offset_dot_depth_vector [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*COORD_WIDTH + 1 : 0 ]  ball_center_offset_dot_width_vector [ 0 : PADDLE_COUNT - 1 ];
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin 
        ball_center_offset[i]                   = trunc_sub(ball.center,    paddles[i].v0);
        depth_vector[i]                         = trunc_sub(paddles[i].v1,  paddles[i].v0);
        width_vector[i]                         = trunc_sub(paddles[i].v2,  paddles[i].v0);
        ball_center_offset_dot_depth_vector[i]  = dot(ball_center_offset[i], depth_vector[i]);
        ball_center_offset_dot_width_vector[i]  = dot(ball_center_offset[i], width_vector[i]);
    end

    always_comb for ( int i = 0; i < PADDLE_COUNT; i++) begin 
        paddles[i].v0       = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}});
        paddles[i].v1       = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}});
        paddles[i].v2       = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}});
        paddles[i].height   = PADDLE_HEIGHT;
    end
endmodule
