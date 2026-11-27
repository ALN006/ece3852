module ball_surface_distances 
    import geometry_pkg::*;
    #(  parameter   int             LOG_EYE_DISTANCE    = 10    )(   
        input       sphere_t        ball,
        input       dist_t          drawX, drawY,
        output      cart_coord_t    surface,
        output      cart_coord_t    surface_wrt_eye
    );
    // TODO: transfer logic from ball_colors into here 
endmodule