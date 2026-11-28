/* verilator lint_off ALWCOMBORDER */
module ball_surface_future // NOTE: surface is being approximaed as a plane intersecting ball at half radius from center
    import geometry_pkg::*;
    #(  parameter   int             LOG_EYE_DISTANCE    = 10,    
        parameter   int             LOOKAHEAD           = 9,
        parameter   dist_t          MAX_DRAWX           = dist_t'(1024),
        parameter   dist_t          MAX_DRAWY           = dist_t'(1024)     )(   
        input       sphere_t        ball,
        input       cart_coord_2d_t draw,
        output      logic           valid,
        output      cart_coord_t    future_surface
    );
    cart_coord_2d_t future_draw;
    forward_index_2d #(
        .INDEX_1D(dist_t),
        .LOOKAHEAD(LOOKAHEAD),
        .BOUND1(MAX_DRAWX), .BOUND2(MAX_DRAWY)              ) future_draw_coords (
        .x(draw.x), .y(draw.y),
        .fwd_x(future_draw.x), .fwd_y(future_draw.y)
    );
    cart_coord_2d_t draw_wrt_eye, future_draw_wrt_eye;
    cart_coord_t    surface_wrt_eye, future_surface_wrt_eye;
    always_comb begin 
        draw_wrt_eye        = trunc_sub_2d(draw, '{ x: ball.center.x, y: ball.center.y });
        future_draw_wrt_eye = trunc_sub_2d(future_draw, '{ x: ball.center.x, y: ball.center.y });
        surface_wrt_eye = '{
            x: dist_t'((surface_wrt_eye.z * draw_wrt_eye.x) >> LOG_EYE_DISTANCE),
            y: dist_t'((surface_wrt_eye.z * draw_wrt_eye.y) >> LOG_EYE_DISTANCE),
            z: dist_t'((ball.center.z + dist_t'(240) + dist_t'(1 << LOG_EYE_DISTANCE) - dist_t'(ball.radius >> 1))) // TODO: that 240 there is lookin random af, make a constant for it in geometry_pkg
        };
        future_surface_wrt_eye = '{
            x: dist_t'((future_surface_wrt_eye.z * future_draw_wrt_eye.x) >>> LOG_EYE_DISTANCE),
            y: dist_t'((future_surface_wrt_eye.z * future_draw_wrt_eye.y) >>> LOG_EYE_DISTANCE),
            z: surface_wrt_eye.z
        };
        future_surface = '{
            x: future_surface_wrt_eye.x + ball.center.x,
            y: future_surface_wrt_eye.y + ball.center.y,
            z: dist_t'(ball.center.z - dist_t'(ball.radius >> 1))
        };
        valid = (surface_wrt_eye.x <= ball.radius) && (surface_wrt_eye.y <= ball.radius);
    end
endmodule
