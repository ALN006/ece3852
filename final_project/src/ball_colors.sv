// TODO: module probably has major timing problems, go ahead and fix that
module ball_colors 
    import geometry_pkg::*;
    #(  parameter   int                     LOG_EYE_DISTANCE                        = 10,
        parameter   int                     COLOR_WIDTH                             = 4,
        parameter   dist_t                  UNIT_DIST                               = (1 << UNIT_SHIFT),
        parameter   dist_t                  MAX_DRAWX                               = dist_t'(1024),
        parameter   dist_t                  MAX_DRAWY                               = dist_t'(1024),
        parameter   angle_t                 UNIT_VECTOR_SEARCH_ANGLE_LOWER_BOUND    = '0,
        parameter   angle_t                 UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND    = PI,
        parameter   cart_coord_t            LIGHT_ORIGIN                            = '{ default: '1 },
        localparam  int                     LATENCY                                 = $clog2(UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND)  + 2   )( 
        input       logic                   clk,
        input       sphere_t                ball,  
        input       dist_t                  drawX, drawY, 
        output      logic                   valid,
        output      dot_t                   brightness
    );

    dist_t drawX_wrt_eye;       assign drawX_wrt_eye        = future_drawX - ball.center.x; 
    dist_t drawY_wrt_eye;       assign drawY_wrt_eye        = future_drawY - ball.center.y;
    dist_t surface_x_wrt_eye;   assign surface_x_wrt_eye    = dist_t'((surface_z_wrt_eye * drawX_wrt_eye) >> LOG_EYE_DISTANCE); // unsigned shift on purpose, to save on comparisons
    dist_t surface_y_wrt_eye;   assign surface_y_wrt_eye    = dist_t'((surface_z_wrt_eye * drawY_wrt_eye) >> LOG_EYE_DISTANCE);
    dist_t surface_z_wrt_eye;   assign surface_z_wrt_eye    = dist_t'((ball.center.z + dist_t'(240) + dist_t'(1 << LOG_EYE_DISTANCE) - dist_t'(ball.radius >> 1)));
    dist_t surface_x;           assign surface_x            = surface_x_wrt_eye + ball.x;
    dist_t surface_y;           assign surface_y            = surface_y_wrt_eye + ball.y;
    dist_t surface_z;           assign surface_z            = dist_t'(ball.center.z - dist_t'(ball.radius >> 1));

    always_ff @(posedge clk) valid <= (surface_x_wrt_eye <= ball.radius) && (surface_y_wrt_eye <= ball.radius);

    polar_2d_coord_t light_unit_vector, normal_unit_vector;
    dir_search_3d #(
        .THETA_LOWER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_LOWER_BOUND),
        .THETA_UPPER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND),
        .PHI_LOWER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_LOWER_BOUND),
        .PHI_UPPER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND)          ) find_normal_and_light_vector[1:0] (
        .clk,
        .origin({LIGHT_ORIGIN, ball.center}),
        .destination('{
                x: surface_x,
                y: surface_y,
                z: surface_z
            }),
        .reset,

        .unit_vector({light_unit_vector, normal_unit_vector})
    );
    assign brightness = dot(polar_to_cart(light_unit_vector), polar_to_cart(normal_unit_vector));
endmodule
