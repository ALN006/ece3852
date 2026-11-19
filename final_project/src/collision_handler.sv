// TODO: complete module rewrite to actually handle collisions
// TODO: better work efficiency
// TODO: better logic
// TODO: confirm that this module meets timing and consider what to do when a module such as this doesnt meet timing (pipeline or slower clock or other)
module collision_handler
    import our_logic_pkg::*;
    #(  parameter   int             PADDLE_COUNT                                        = 2 )(
        input       polar_coord_t   paddles                 [ 0 : PADDLE_COUNT - 1 ],
        input       sphere_t        ball,
        input       cart_coord_t    current_ball_velocity,
        output      cart_coord_t    next_ball_velocity
    );
    dot_t           in_theta_dir                        [ 0 : PADDLE_COUNT - 1 ];
    dot_t           upper_bound_in_theta_dir            [ 0 : PADDLE_COUNT - 1 ];
    dot_t           in_phi_dir                          [ 0 : PADDLE_COUNT - 1 ];
    dot_t           upper_bound_in_phi_dir              [ 0 : PADDLE_COUNT - 1 ];
    dot_t           ball_distance_from_paddle_center    [ 0 : PADDLE_COUNT - 1 ];
    cart_coord_t    outward_normal_vector               [ 0 : PADDLE_COUNT - 1 ];
    ball_paddle_offset_projections #(
        .PADDLE_COUNT(PADDLE_COUNT) // TODO : confirm this syntax
    ) projections (
        .paddles,
        .ball,

        .in_theta_dir,
        .upper_bound_in_theta_dir,
        .in_phi_dir,
        .upper_bound_in_phi_dir,
        .ball_distance_from_paddle_center,
        .outward_normal_vector
    );
    
    logic [ PADDLE_COUNT - 1 : 0 ]   hit;
    logic found [ 0 : PADDLE_COUNT - 1 ]; 
    always_comb begin
        hit[0] = (
            ($signed('0)        < in_theta_dir[0])                                                                          &&
            (in_theta_dir[0]    < upper_bound_in_theta_dir[0])                                                              &&
            ($signed('0)        < in_phi_dir[0])                                                                            &&
            (in_phi_dir[0]      < upper_bound_in_phi_dir[0])                                                                &&
            (-(ball.radius + PADDLE_HALF_RADIUS_OFFSET) < dist_t'(ball_distance_from_paddle_center[0] >> DIST_WIDTH - 2))   &&
            ( dist_t'(ball_distance_from_paddle_center[0] >> DIST_WIDTH - 2) < (ball.radius + PADDLE_HALF_RADIUS_OFFSET))
        );
        for (int i = 0; i < PADDLE_COUNT; i++) found[i] = &{hit[i:0]}; // Interesting choice, dk if synthesizer will optimize away
        for (int i = 1; i < PADDLE_COUNT; i++) begin
            hit[i] = (
                ($signed('0)        < in_theta_dir[i])                                                                          &&
                (in_theta_dir[i]    < upper_bound_in_theta_dir[i])                                                              &&
                ($signed('0)        < in_phi_dir[i])                                                                            &&
                (in_phi_dir[i]      < upper_bound_in_phi_dir[i])                                                                &&
                (-(ball.radius + PADDLE_HALF_RADIUS_OFFSET) < dist_t'(ball_distance_from_paddle_center[0] >> DIST_WIDTH - 2))   &&
                ( dist_t'(ball_distance_from_paddle_center[0] >> DIST_WIDTH - 2) < (ball.radius + PADDLE_HALF_RADIUS_OFFSET))   &&
                ~found[i-1] // TODO: this collision resolution may not meet timing, maybe think of another way
            );
        end
        if (found[PADDLE_COUNT - 1] == 1'b1) begin
            for (int i = 1; i < PADDLE_COUNT; i++) begin
                if (hit[i] == 1'b1) 
                    if (dist_t'(ball_distance_from_paddle_center[0] >> DIST_WIDTH - 2) > $signed(0)) begin
                        next_ball_velocity = trunc_add(current_ball_velocity, '{
                                x: dist_t'((2 * (outward_normal_vector[i].x ) * dot( outward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 4)),
                                y: dist_t'((2 * (outward_normal_vector[i].y ) * dot( outward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 4)),
                                z: dist_t'((2 * (outward_normal_vector[i].z ) * dot( outward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 4))
                            });
                    end else begin 
                        next_ball_velocity = trunc_add(current_ball_velocity, '{
                                x: dist_t'((2 * (-outward_normal_vector[i].x ) * dot( -outward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 4)),
                                y: dist_t'((2 * (-outward_normal_vector[i].y ) * dot( -outward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 4)),
                                z: dist_t'((2 * (-outward_normal_vector[i].z ) * dot( -outward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 4))
                            });
                    end
            end
        end else begin 
            next_ball_velocity = current_ball_velocity;
        end
    end
endmodule
