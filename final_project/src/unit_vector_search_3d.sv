module unit_vector_search_3d 
    import geometry_pkg::*;
    #(  parameter   dist_t              unit_radius         = (1 << DIST_WIDTH - 1);
        parameter   angle_t             theta_lower_bound   = '0,
        parameter   angle_t             theta_upper_bound   = PI,
        parameter   angle_t             phi_lower_bound     = '0,
        parameter   polar_2d_coord_t    phi_upper_bound     = PI,
        localparam  integer             xy_cycles           = $clog2(theta_upper_bound),
        localparam  integer             zx_cycles           = $clog2(phi_upper_bound)  )(
        input       logic               clk,
        input       cart_coord_t        origin,
        input       cart_coord_t        destination,
        input       logic               req,
        input       logic               reset,
        output      logic               done,
        output      polar_coord_t       unit_vector
    );
    assign done = phi_found & theta_found;
    assign unit_vector = '{
        radius: unit_radius,
        theta:  theta_vector,
        phi:    phi_vector,
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

    logic               theta_found;
    polar_2d_coord_t    theta_vector;
    unit_vector_search_2d #(
        .unit_radius(unit_radius),
        .lower_bound_angle(theta_lower_bound),
        .upper_bound_angle(theta_upper_bound)
    ) search_theta (
        .clk,
        .target(point_offset_origin_xy),
        .req,
        .reset,

        .done(theta_found),
        .unit_vector(theta_vector)
    );

    logic               phi_found;
    polar_2d_coord_t    phi_vector;
    unit_vector_search_2d #(
        .unit_radius(unit_radius),
        .lower_bound_angle(phi_lower_bound),
        .upper_bound_angle(phi_upper_bound)
    ) search_phi (
        .clk,
        .target(point_offset_origin_zx),
        .req,
        .reset,

        .done(phi_found),
        .unit_vector(phi_vector)
    );
endmodule
