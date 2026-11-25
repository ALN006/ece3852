module occlusion_handling_color_mapper 
    import our_logic_pkg::*;
    #(  parameter   int                                         COLOR_WIDTH     = 4,
        parameter   int                                         PADDLE_COUNT    = 2,
        parameter   cart_coord_t                                LIGHT_ORIGIN    = '{ default: '1}   )(
        input       logic                                       clk,
        input       logic                                       pix_clk,    // TODO: determine what this is neccesary for
        input       dist_t                                      drawX, drawY,
        input       sphere_t                                    ball,
        input       polar_coord_t                               paddles             [ 0 : PADDLE_COUNT - 1 ]
        output      logic           [ COLOR_WIDTH   - 1 : 0 ]   red, green, blue
    );
    paddle_projections paddles_on_screen_area ( // TODO: nick kindly give me this module
        .paddles,

        .paddles_2d
    );
    sparse_color_mapper draw_objects (  // TODO: nick please handle the paddle drawing and occlusion here, I can help with the sphere drawing
        .drawX, .drawY,
        .paddles,
        .paddles_2d,
        .ball,

        .is_object
        .red, .green, .blue
    );
    always_ff @(posedge clk ) begin : draw_background

    end
endmodule
