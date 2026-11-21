module light_vector 
    import our_logic_pkg::*;
    #(  parameter   polar_2d_coord_t    xy_lower_bound  = '{ radius: (1 << DIST_WIDTH - 1), theta: '0 },
        parameter   polar_2d_coord_t    xy_upper_bound  = '{ radius: (1 << DIST_WIDTH - 1), theta: PI },
        parameter   polar_2d_coord_t    zx_lower_bound  = '{ radius: (1 << DIST_WIDTH - 1), theta: '0 },
        parameter   polar_2d_coord_t    zx_upper_bound  = '{ radius: (1 << DIST_WIDTH - 1), theta: PI } 
        localparam  integer             xy_cycles       = $clog2(xy_upper_bound.theta),
        localparam  integer             zx_cycles       = $clog2(xy_upper_bound.theta)  )(
        input       logic               clk,
        input       cart_coord_t        beam_origin,
        input       cart_coord_t        surface_point,
        input       logic               req,
        output      logic               done,
        output      cart_coord_t        light_unit_vector
    );
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
            z: point_offset_beam_origin.z,
            x: point_offset_beam_origin.x
        };
    end
    polar_2d_coord_t            curr_xy_lower;
    polar_2d_coord_t            curr_xy;
    polar_2d_coord_t            curr_xy_upper;
    logic [xy_cycles - 1 : 0 ]  xy_cycle;
    polar_2d_coord_t            curr_zx_lower;
    polar_2d_coord_t            curr_zx_upper;
    polar_2d_coord_t            curr_zx;
    logic [xy_cycles - 1 : 0 ]  zx_cycle;
    // TODO: MAKE: a binary search module and instantiate 2 of them 
endmodule