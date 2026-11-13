/* verilator lint_off UNUSEDSIGNAL */   
// TODO: There is a lot of documentation/diagrams that can and perhaps should accompany this code, figure out how to go about that 
// TODO: The next thing to figure out for this guy is probably a colision detection mechanism which I imagine will involve calculating the distance between a point and some planes :)

module physics_engine #(
    parameter int                           MAX_SIMULTAENEOUS_KEYCODES  = 6, 
    parameter int                           KEYCODE_WIDTH               = 8,   
    parameter int                           COORD_WIDTH                 = 10,
    parameter int                           PADDLE_COUNT                = 2,
    parameter logic [ COORD_WIDTH - 1 : 0 ] PADDLE_WIDTH                = COORD_WIDTH'(60),
    parameter logic [ COORD_WIDTH - 1 : 0 ] PADDLE_HEIGHT               = COORD_WIDTH'(40),
    parameter logic [ COORD_WIDTH - 1 : 0 ] BALL_RADIUS                 = COORD_WIDTH'(20) 
)(
    input   logic                                   clk,
    input   logic                                   calc_now,
    input   logic [ KEYCODE_WIDTH       - 1 : 0 ]   keycodes    [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1 ],
    
    output  our_logic_types_pkg::sphere_t           ball,
    output  our_logic_types_pkg::cuboid_t           paddles     [ 0 : PADDLE_COUNT                  - 1 ]
);
    assign ball.radius      = BALL_RADIUS;
    assign ball.center.x    = { COORD_WIDTH/2 {2'b10} };
    assign ball.center.y    = { COORD_WIDTH/2 {2'b10} };
    assign ball.center.z    = { COORD_WIDTH/2 {2'b10} };

    always_comb for ( int i = 0; i < PADDLE_COUNT; i++) begin 
        paddles[i].v0.x     = { COORD_WIDTH/2 {2'b10} };
        paddles[i].v0.y     = { COORD_WIDTH/2 {2'b10} };
        paddles[i].v0.z     = { COORD_WIDTH/2 {2'b10} };
        paddles[i].v1.x     = { COORD_WIDTH/2 {2'b10} };
        paddles[i].v1.y     = { COORD_WIDTH/2 {2'b10} };
        paddles[i].v1.z     = { COORD_WIDTH/2 {2'b10} };
        paddles[i].width    = PADDLE_WIDTH;
        paddles[i].height   = PADDLE_HEIGHT;
    end
endmodule
