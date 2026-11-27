module sparse_object_color_mapper 
    import geometry_pkg::*;
    #(  parameter   int COLOR_WIDTH = 4                     )(
        input       dist_t                  drawX, drawY,
        input       polar_coord_t           paddles [0:PADDLE_COUNT-1],
        input       cart_coord_t [7:0]      paddles_2d [0:PADDLE_COUNT-1],
        input       sphere_t                ball,
        input       logic                   clk,
        input       logic                   frame_tick,
        input       logic                   reset,
        output      logic                   is_object,
        output      logic [COLOR_WIDTH-1:0] red, green, blue
    );

    ball_colors occlusion_agnostic_ball_colors (
        .drawX, .drawY,
        .ball,
        .clk,

        .valid,
        .brightness
    );

    cart_coord_t origin;
    cart_coord_t surface_point [(PADDLE_COUNT*6)-1:0];
    polar_coord_t polar_normal_inward_unit_vector [(PADDLE_COUNT*6)-1:0];
    cart_coord_t cart_normal_inward_unit_vector [(PADDLE_COUNT*6)-1:0];
    cart_coord_t cart_light_unit_vector [0:(PADDLE_COUNT*6)-1];
    always_comb begin
        origin = {0, 0, 20};   // TODO: FIX: at minimum this is a sysntax error
        // comment names for each surface point derived from the vertices which enclose it
        for (int i = 0; i < PADDLE_COUNT; i++) begin
            surface_point[0 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta}); // for face 1357
            surface_point[1 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi, paddles[i].theta + PADDLE_HALF_THETA_OFFSET}); // for face 1256
            surface_point[2 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta + PADDLE_THETA_OFFSET}); // for face 2468
            surface_point[3 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta + PADDLE_HALF_THETA_OFFSET}); // for face 3478
            surface_point[4 + i*6] = polar_to_cart({paddles[i].radius, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta + PADDLE_HALF_THETA_OFFSET}); // for face 1234
            surface_point[5 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta + PADDLE_HALF_THETA_OFFSET});
        
        
            normal_inward_unit_vector[0 + i*6] = '{
                radius:    (1 << DIST_WIDTH - 1), // for face 1357
                phi:       ((paddles[i].phi + PADDLE_HALF_PHI_OFFSET) >= ANGLE_WIDTH'(360)) ? (paddles[i].phi + PADDLE_HALF_PHI_OFFSET - ANGLE_WIDTH'(360)) : (paddles[i].phi + PADDLE_HALF_PHI_OFFSET), 
                theta:     ((paddles[i].theta + ANGLE_WIDTH'(90)) >= ANGLE_WIDTH'(360)) ? (paddles[i].theta + ANGLE_WIDTH'(90) - ANGLE_WIDTH'(360)) : (paddles[i].theta + ANGLE_WIDTH'(90))
            };
            normal_inward_unit_vector[1 + i*6] = '{
                radius:    (1 << DIST_WIDTH - 1), // for face 1256
                phi:       ((paddles[i].phi + ANGLE_WIDTH'(90)) >= ANGLE_WIDTH'(360)) ? (paddles[i].phi + ANGLE_WIDTH'(90) - ANGLE_WIDTH'(360)) : (paddles[i].phi + ANGLE_WIDTH'(90)),
                theta:     ((paddles[i].theta + PADDLE_HALF_THETA_OFFSET) >= ANGLE_WIDTH'(360)) ? (paddles[i].theta + PADDLE_HALF_THETA_OFFSET - ANGLE_WIDTH'(360)) : (paddles[i].theta + PADDLE_HALF_THETA_OFFSET)
            };
            normal_inward_unit_vector[2 + i*6] = '{
                radius:    (1 << DIST_WIDTH - 1), // for face 2468
                phi:       ((paddles[i].phi + PADDLE_HALF_PHI_OFFSET) >= ANGLE_WIDTH'(360)) ? (paddles[i].phi + PADDLE_HALF_PHI_OFFSET - ANGLE_WIDTH'(360)) : (paddles[i].phi + PADDLE_HALF_PHI_OFFSET), 
                theta:     ((paddles[i].theta + ANGLE_WIDTH'(270)) >= ANGLE_WIDTH'(360)) ? (paddles[i].theta + ANGLE_WIDTH'(270) - ANGLE_WIDTH'(360)) : (paddles[i].theta + ANGLE_WIDTH'(270))
            };
            normal_inward_unit_vector[3 + i*6] = '{
                radius:    (1 << DIST_WIDTH - 1), // for face 3478
                phi:       ((paddles[i].phi + ANGLE_WIDTH'(90)) >= ANGLE_WIDTH'(360)) ? (paddles[i].phi + ANGLE_WIDTH'(90) - ANGLE_WIDTH'(360)) : (paddles[i].phi + ANGLE_WIDTH'(90)),
                theta:     ((paddles[i].theta + PADDLE_HALF_THETA_OFFSET) >= ANGLE_WIDTH'(360)) ? (paddles[i].theta + PADDLE_HALF_THETA_OFFSET - ANGLE_WIDTH'(360)) : (paddles[i].theta + PADDLE_HALF_THETA_OFFSET)
            };
            normal_inward_unit_vector[4 + i*6] = '{
                radius:    (1 << DIST_WIDTH - 1), // for face 1234
                phi:       ((paddles[i].phi + PADDLE_HALF_PHI_OFFSET) >= ANGLE_WIDTH'(360)) ? (paddles[i].phi + PADDLE_HALF_PHI_OFFSET - ANGLE_WIDTH'(360)) : (paddles[i].phi + PADDLE_HALF_PHI_OFFSET), 
                theta:     ((paddles[i].theta + PADDLE_HALF_THETA_OFFSET) >= ANGLE_WIDTH'(360)) ? (paddles[i].theta + PADDLE_HALF_THETA_OFFSET - ANGLE_WIDTH'(360)) : (paddles[i].theta + PADDLE_HALF_THETA_OFFSET)
            };
            normal_inward_unit_vector[5 + i*6] = '{
                radius:    (1 << DIST_WIDTH - 1), // for face 1234
                phi:       ((paddles[i].phi + PADDLE_HALF_PHI_OFFSET + ANGLE_WIDTH'(180)) >= ANGLE_WIDTH'(360)) ? (paddles[i].phi + PADDLE_HALF_PHI_OFFSET + ANGLE_WIDTH'(180) - ANGLE_WIDTH'(360)) : (paddles[i].phi + PADDLE_HALF_PHI_OFFSET + ANGLE_WIDTH'(180)), 
                theta:     ((paddles[i].theta + PADDLE_HALF_THETA_OFFSET + ANGLE_WIDTH'(180)) >= ANGLE_WIDTH'(360)) ? (paddles[i].theta + PADDLE_HALF_THETA_OFFSET + ANGLE_WIDTH'(180) - ANGLE_WIDTH'(360)) : (paddles[i].theta + PADDLE_HALF_THETA_OFFSET + ANGLE_WIDTH'(180))
            };
        end
        for (int i = 0; i < PADDLE_COUNT * 6; i++) begin
            cart_normal_inward_unit_vector[i] = polar_to_cart(polar_normal_inward_unit_vector[i]);
            cart_light_unit_vector[i] = polar_to_cart(polar_light_unit_vector[i]);
        end
    end

    polar_coord_t polar_light_unit_vector [0:(PADDLE_COUNT*6)-1] ;
    generate // generate for loop structure inspired by the following: https://stackoverflow.com/questions/33899691/instantiate-modules-in-generate-for-loop-in-verilog
        for (genvar i = 0; i < (6 << $clog2(PADDLE_COUNT)); i++) begin : face_vector_calcs
            unit_vector_search_3d #(

            ) face_calcs (
                .clk,
                .origin,
                .destination(surface_point[i]),
                .reset,

                .unit_vector(polar_light_unit_vector[i])
            );

            shading_calc #(

            ) shading_calcs (
                .light_unit_vector(cart_light_unit_vector[i]),
                .normal_unit_vector(cart_normal_inward_unit_vector[i]),
                .red, .green, .blue, // TODO: set a value to send to these

                .shaded_red, .shaded_green, .shaded_blue // TODO: set up the signals to accept these
            );
        end 
    endgenerate
endmodule