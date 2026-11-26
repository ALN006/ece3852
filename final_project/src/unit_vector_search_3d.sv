module unit_vector_search_3d 
    import geometry_pkg::*;
    #(  parameter   dist_t              UNIT_RADIUS         = (1 << DIST_WIDTH - 1);
        parameter   angle_t             THETA_LOWER_BOUND   = '0,
        parameter   angle_t             THETA_UPPER_BOUND   = PI,
        parameter   angle_t             PHI_LOWER_BOUND     = '0,
        parameter   polar_2d_coord_t    PHI_UPPER_BOUND     = PI        )(
        input       logic               clk,
        input       cart_coord_t        origin,
        input       cart_coord_t        destination,
        input       logic               reset,
        output      polar_coord_t       unit_vector
    );
    assign unit_vector = '{
        radius: UNIT_RADIUS,
        theta:  theta_vector.theta,
        phi:    phi_vector.theta,
    };
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

    polar_2d_coord_t    theta_vector;
    unit_vector_search_2d #(
        .UNIT_RADIUS(UNIT_RADIUS),
        .LOWER_BOUND_ANGLE(THETA_LOWER_BOUND),
        .UPPER_BOUND_ANGLE(THETA_UPPER_BOUND)
    ) search_theta (
        .clk,
        .target(point_offset_origin_xy),
        .reset,

        .unit_vector(theta_vector)
    );
    polar_2d_coord_t    phi_vector;
    unit_vector_search_2d #(
        .UNIT_RADIUS(UNIT_RADIUS),
        .LOWER_BOUND_ANGLE(PHI_LOWER_BOUND),
        .UPPER_BOUND_ANGLE(PHI_UPPER_BOUND)
    ) search_phi (
        .clk,
        .target(point_offset_origin_zx),
        .reset,

        .unit_vector(phi_vector)
    );
endmodule
