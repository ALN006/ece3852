module light_vector 
    import our_logic_pkg::*;
    #(  parameter   dist_t              unit_radius         = (1 << DIST_WIDTH - 1);
        parameter   angle_t             theta_lower_bound   = '0,
        parameter   angle_t             theta_upper_bound   = PI,
        parameter   angle_t             phi_lower_bound     = '0,
        parameter   polar_2d_coord_t    phi_upper_bound     = PI,
        localparam  integer             xy_cycles           = $clog2(theta_upper_bound),
        localparam  integer             zx_cycles           = $clog2(phi_upper_bound)  )(
        input       logic               clk,
        input       cart_coord_t        beam_origin,
        input       cart_coord_t        surface_point,
        input       logic               req,
        input       logic               reset,
        output      logic               done,
        output      polar_coord_t       light_unit_vector
    );
    assign done = phi_found & theta_found;
    assign light_unit_vector = '{
        radius: unit_radius,
        theta:  theta,
        phi:    phi,
    };
    cart_coord_t    point_offset_beam_origin;
    cart_2d_coord_t point_offset_beam_origin_xy;
    cart_2d_coord_t point_offset_beam_origin_zx;
    always_comb begin : beam_origin_offset_vectors
        point_offset_beam_origin    = trunc_sub( surface_point, beam_origin );
        point_offset_beam_origin_xy = '{
            x: point_offset_beam_origin.x,
            y: point_offset_beam_origin.y
        };
        point_offset_beam_origin_zx = '{
            x: point_offset_beam_origin.z,
            y: point_offset_beam_origin.x
        };
    end

    logic   theta_found;
    angle_t theta;
    binary_light_search #(
        .unit_radius(unit_radius),
        .lower_bound_angle(theta_lower_bound),
        .upper_bound_angle(theta_upper_bound)
    ) search_theta (
        .clk,
        .target(point_offset_beam_origin_xy),
        .req,
        .reset,

        .done(theta_found),
        .angle(theta)
    );

    logic   phi_found;
    angle_t phi;
    binary_light_search #(
        .unit_radius(unit_radius),
        .lower_bound_angle(phi_lower_bound),
        .upper_bound_angle(phi_upper_bound)
    ) search_phi (
        .clk,
        .target(point_offset_beam_origin_zx),
        .req,
        .reset,

        .done(phi_found),
        .angle(phi)
    );
endmodule
