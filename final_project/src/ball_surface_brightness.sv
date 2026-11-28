// TODO: module probably has major timing problems, go ahead and fix that
module ball_surface_brightness
    import geometry_pkg::*;
    #(  parameter   int                     LOG_EYE_DISTANCE                        = 10,
        parameter   int                     LOG_MAX_BRIGHTNESS_SQRT                 = UNIT_SHIFT, // sqrt of max brightness
        parameter   dist_t                  MAX_DRAWX                               = dist_t'(1024),
        parameter   dist_t                  MAX_DRAWY                               = dist_t'(1024),
        localparam  angle_t                 UNIT_VECTOR_SEARCH_ANGLE_LOWER_BOUND    = '0,
        localparam  angle_t                 UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND    = PI,
        parameter   cart_coord_t            LIGHT_ORIGIN                            = '{ default: '1 },
        parameter   int                     PIXELS_SET_PER_CLK                      = 4,
        localparam  int                     LATENCY                                 = $clog2(UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND)  + 3,
        localparam  int                     LANE_SEL_VAR_WIDTH                      = (LATENCY > 1) ? $clog2(LATENCY) : 1                    )( 
        input       logic                   clk,
        input       sphere_t                ball,  
        input       cart_coord_2d_t         draw, 
        output      logic                   valid,
        output      dot_t                   brightness
    );
    cart_coord_t    future_surface;
    ball_surface_future #(
        .LOG_EYE_DISTANCE(LOG_EYE_DISTANCE),
        .LOOKAHEAD(LATENCY * PIXELS_SET_PER_CLK),
        .MAX_DRAWX(MAX_DRAWX), .MAX_DRAWY(MAX_DRAWY)                    ) surface_corresponding_to_pixel_latency_clock_cycles_ahead (
        .ball,
        .draw,

        .valid,
        .future_surface
    );

    logic [ LANE_SEL_VAR_WIDTH - 1 : 0 ] lane;
    cart_coord_t light_vec, normal_vec;
    always_ff @( posedge clk ) begin 
        lane <= (lane < LANE_SEL_VAR_WIDTH'(LATENCY)) ? lane + 1 : '0;

        light_vec <= polar_to_cart('{ radius: 1 << LOG_MAX_BRIGHTNESS_SQRT, theta: light_theta[lane], phi: light_phi[lane]});
        normal_vec <= polar_to_cart('{ radius: 1 << LOG_MAX_BRIGHTNESS_SQRT, theta: normal_theta[lane], phi: normal_phi[lane]});

        brightness <= dot(light_vec, normal_vec);
    end

    cart_coord_t    destination     [ 0 : LATENCY - 1 ];  
    logic           restart         [ 0 : LATENCY - 1 ];
    angle_t         light_theta     [ 0 : LATENCY - 1 ];
    angle_t         light_phi       [ 0 : LATENCY - 1 ];
    angle_t         normal_theta    [ 0 : LATENCY - 1 ];
    angle_t         normal_phi      [ 0 : LATENCY - 1 ];
    generate
        for (genvar i = 0;  i < LATENCY; i++) begin : vector_search_lane
            assign restart[i] = (lane == i);
            always_ff @(posedge clk) if (restart[i]) destination[i] <= future_surface;
            dir_search_3d #(
                .THETA_LOWER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_LOWER_BOUND),
                .THETA_UPPER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND),
                .PHI_LOWER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_LOWER_BOUND),
                .PHI_UPPER_BOUND(UNIT_VECTOR_SEARCH_ANGLE_UPPER_BOUND)          ) find_normal_and_light_vector[1:0] (
                .clk,
                .origin({LIGHT_ORIGIN, ball.center}),
                .destination(destination[i]),
                .restart(restart[i]),

                .theta({light_theta[i], normal_theta[i]}),
                .phi({light_phi[i], normal_phi[i]})
            );
        end
    endgenerate
endmodule
