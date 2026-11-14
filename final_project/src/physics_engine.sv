/* verilator lint_off UNUSEDSIGNAL */
/* verilator lint_off UNUSEDPARAM */   
// TODO: There is a lot of documentation/diagrams that can and perhaps should accompany this code, figure out how to go about that 
// TODO: The next thing to figure out for this guy is probably a colision detection mechanism which I imagine will involve calculating the distance between a point and some planes :)

module physics_engine #(
    parameter int                                       MAX_SIMULTAENEOUS_KEYCODES  = 6, 
    parameter int                                       KEYCODE_WIDTH               = 8,   
    parameter int                                       COORD_WIDTH                 = 11,
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
    
    output  our_logic_types_pkg::sphere_t               ball,
    output  our_logic_types_pkg::cuboid_t               paddles     [ 0 : PADDLE_COUNT                  - 1 ]
);
    assign ball.radius = BALL_RADIUS;

    logic signed [ 3*COORD_WIDTH - 1 : 0 ] ball_velocity;
    always @( posedge clk ) begin 
        if (reset == 1'b1) begin 
            ball.center     <= BALL_RESTART_LOCATION;
            ball_velocity   <= BALL_RESTART_VELOCITY;
        end else begin 
            ball.center <= { 
                COORD_WIDTH'(ball.center[ 2 * COORD_WIDTH +: COORD_WIDTH ] + ball_velocity[ 2 * COORD_WIDTH +: COORD_WIDTH ]), 
                COORD_WIDTH'(ball.center[ 1 * COORD_WIDTH +: COORD_WIDTH ] + ball_velocity[ 1 * COORD_WIDTH +: COORD_WIDTH ]), 
                COORD_WIDTH'(ball.center[ 0 * COORD_WIDTH +: COORD_WIDTH ] + ball_velocity[ 0 * COORD_WIDTH +: COORD_WIDTH ])
            };
        end
    end 

    // TODO: write an offset module to avoid repetition here
    our_logic_types_pkg::point_3d_t ball_center_offset  [ 0 : PADDLE_COUNT - 1 ];
    our_logic_types_pkg::point_3d_t width_vector        [ 0 : PADDLE_COUNT - 1 ];
    our_logic_types_pkg::point_3d_t depth_vector        [ 0 : PADDLE_COUNT - 1 ];
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin 
        ball_center_offset[i] = {
            COORD_WIDTH'(ball.center[ 2 * COORD_WIDTH +: COORD_WIDTH ] - paddles[i].v0.x),
            COORD_WIDTH'(ball.center[ 1 * COORD_WIDTH +: COORD_WIDTH ] - paddles[i].v0.y), 
            COORD_WIDTH'(ball.center[ 0 * COORD_WIDTH +: COORD_WIDTH ] - paddles[i].v0.z)
        };
        width_vector[i] = {
            COORD_WIDTH'(paddles[i].v2.x - paddles[i].v0.x),
            COORD_WIDTH'(paddles[i].v2.y - paddles[i].v0.y),
            COORD_WIDTH'(paddles[i].v2.z - paddles[i].v0.z),
        };
        depth_vector[i] = {
            COORD_WIDTH'(paddles[i].v2.x - paddles[i].v0.x),
            COORD_WIDTH'(paddles[i].v2.y - paddles[i].v0.y),
            COORD_WIDTH'(paddles[i].v2.z - paddles[i].v0.z),
        };
    end

    logic signed [ COORD_WIDTH   - 1 : 0 ] ball_center_offset_dot_width_vector [ 0 : PADDLE_COUNT - 1 ]; // ball center offset = ball center - v0
    logic signed [ COORD_WIDTH   - 1 : 0 ] ball_center_offset_dot_depth_vector [ 0 : PADDLE_COUNT - 1 ]; // depth vector = v1 - v0
    generate
        for (genvar i = 0; i < PADDLE_COUNT; i++) begin : dot_products
            dot_product_combinational #(
                .DIMENSIONS(3),
                .COORD_WIDTH(COORD_WIDTH),
            ) dot_product [0:1] (
                // TODO: fill in the connections here
            );
        end
    endgenerate

    always_comb for ( int i = 0; i < PADDLE_COUNT; i++) begin 
        paddles[i].v0           = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}});
        paddles[i].v1           = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}});
        paddles[i].width_vector = (3*COORD_WIDTH)'({(3*COORD_WIDTH + 1)/2 {2'b10}});
        paddles[i].height       = PADDLE_HEIGHT;
    end
endmodule
