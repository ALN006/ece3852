module occlusion_handling_color_mapper 
    import geometry_pkg::*;
    #(  parameter   int                                         COLOR_WIDTH         = 4,
        parameter   int                                         PADDLE_COUNT        = 2,
        parameter   cart_coord_t                                LIGHT_ORIGIN        = '{ default: '1},
        parameter   int                                         LOG_EYE_DISTANCE    = 10   )( // ASSUPTION: the xy possition is the same as that of the ball
        input       logic                                       clk,
        input       logic                                       pix_clk,    // TODO: determine what this is neccesary for
        input       dist_t                                      drawX, drawY,
        input       sphere_t                                    ball,
        input       polar_coord_t                               paddles             [ 0 : PADDLE_COUNT - 1 ],
        input       logic                                       frame_tick,
        input       logic                                       reset,
        output      logic           [ COLOR_WIDTH   - 1 : 0 ]   red, green, blue
    );
    cart_coord_t [7:0] paddles_2d [0:PADDLE_COUNT-1];
    paddle_projections paddles_on_screen_area ( // TODO: nick kindly give me this module
        .clk,
        .reset,
        .frame_tick,
        .paddles,

        .paddles_2d
    );
    sparse_object_color_mapper draw_objects (  // TODO: nick please handle the paddle drawing and occlusion here, I can help with the sphere drawing
        .drawX, .drawY,
        .paddles,
        .paddles_2d,
        .ball,
        .clk,
        .frame_tick,
        .reset,

        .is_object, // I'm taking this to mean "there is an object displayed in this pixel"
        .red, .green, .blue
    );
    always_ff @(posedge clk ) begin : draw_background

    end
endmodule
