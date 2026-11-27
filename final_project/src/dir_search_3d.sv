module dir_search_3d // NOTE: it is neccessary to assert reset to find a new direction
    import geometry_pkg::*;
    #(  parameter   angle_t             THETA_LOWER_BOUND   = '0,
        parameter   angle_t             THETA_UPPER_BOUND   = PI,
        parameter   angle_t             PHI_LOWER_BOUND     = '0,
        parameter   angle_t             PHI_UPPER_BOUND     = PI        )(
        input       logic               clk,
        input       cart_coord_t        origin,
        input       cart_coord_t        destination,
        input       logic               reset,
        output      angle_t             theta,
        output      angle_t             phi
    );
    cart_coord_t    point_offset_origin;
    cart_2d_coord_t point_offset_origin_xy;
    cart_2d_coord_t point_offset_origin_zx;
    always_comb begin : origin_offset_vectors
        point_offset_origin    = trunc_sub( destination, origin );
        point_offset_origin_xy = '{
            x: point_offset_origin.x,
            y: point_offset_origin.y
        };
        point_offset_origin_zx = '{
            x: point_offset_origin.z,
            y: point_offset_origin.x
        };
    end
    dir_search_2d #(
        .LOWER_BOUND_ANGLE(THETA_LOWER_BOUND),
        .UPPER_BOUND_ANGLE(THETA_UPPER_BOUND)       
    ) search_theta (
        .clk, .reset,
        .target(point_offset_origin_xy),

        .direction(theta)
    );
    dir_search_2d #(
        .LOWER_BOUND_ANGLE(PHI_LOWER_BOUND),
        .UPPER_BOUND_ANGLE(PHI_UPPER_BOUND)        
    ) search_phi (
        .clk, .reset,
        .target(point_offset_origin_zx),

        .direction(phi)
    );
endmodule
