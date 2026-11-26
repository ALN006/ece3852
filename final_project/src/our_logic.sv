module our_logic 
    import our_logic_pkg::*;
    #(  parameter   int                                         KEYCODES_PER_PADDLE                                                     = 3,
        parameter   int                                         KEYCODE_WIDTH                                                           = 8,
        parameter   logic signed [ KEYCODE_WIDTH   - 1 : 0 ]    INPUT_KEYS              [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE    - 1 ] = '{ default: '1}
        parameter   int                                         COLOR_WIDTH                                                             = 10,
        parameter   int                                         PADDLE_COUNT                                                            = 2,
        parameter   polar_coord_t                               PADDLE_AT_RESTART                                                       = '{ default: '1},
        parameter   sphere_t                                    BALL_AT_RESTART                                                         = '{ default: '1},     
        parameter   cart_coord_t                                BALL_RESTART_VELOCITY                                                   = '{ default: '1},
        parameter   cart_coord_t                                LIGHT_ORIGIN                                                            = '{ default: '1}  )(
        input       logic                                       clk,
        input       logic                                       pix_clk,
        input       logic                                       reset,
        input       dist_t                                      drawX, drawY,
        input       logic [ KEYCODE_WIDTH   - 1 : 0 ]           keycodes                [ 0 : PADDLE_COUNT*KEYCODES_PER_PADDLE    - 1],
        output      logic [ COLOR_WIDTH     - 1 : 0 ]           red, green, blue
    );
    occlusion_handling_color_mapper #(
        .ADDRESS_BITS(`address_bits),
        .COLOR_BITS(COLOR_WIDTH),
        .COORD_BITS(DIST_WIDTH),
        .MAX_OBJS_ON_SCREEN(`max_objs_on_screen)  
    ) draw_logic (   // TODO: implement this to handle occlusion
        .clk,           // TODO: consider passing in faster clock
        .pix_clk,
        .ball,
        .paddles,
        .drawX, .drawY,
        .frame_tick,
        .reset,

        .red, .green, .blue 
    ); 
    logic           frame_tick; // TODO: drive based on drawX drawY
    sphere_t        ball;
    polar_coord_t   paddles [ 0 : PADDLE_COUNT - 1 ];
    physics_engine # (
        .KEYCODES_PER_PADDLE(KEYCODES_PER_PADDLE),
        .KEYCODE_WIDTH(KEYCODE_WIDTH),
        .PADDLE_COUNT(PADDLE_COUNT),
        .PADDLE_AT_RESTART(PADDLE_AT_RESTART),
        .BALL_AT_RESTART(BALL_AT_RESTART),
        .INPUT_KEYS(INPUT_KEYS)  
    ) frame_gen_logic (   // TODO: implement everything but occlusion handling here 
        .clk,
        .frame_tick,
        .reset,
        .keycodes,
        
        .ball,
        .paddles
    );
endmodule
