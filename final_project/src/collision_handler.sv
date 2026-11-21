// TODO: HIGH PRIORTY, INVESTIGATE: it seems to me based physics_engine.sv that this code will yield an inifinate spped up glitch, not good
// TODO: better collision logic
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
    dist_t          ball_distance_from_paddle_center    [ 0 : PADDLE_COUNT - 1 ];
    cart_coord_t    inward_normal_vector                [ 0 : PADDLE_COUNT - 1 ];   //TODO: consider making this an output
    ball_paddle_offset_projections #(
        .PADDLE_COUNT(PADDLE_COUNT)
    ) projections (
        .paddles,
        .ball,

        .in_theta_dir,
        .upper_bound_in_theta_dir,
        .in_phi_dir,
        .upper_bound_in_phi_dir,
        .ball_distance_from_paddle_center,
        .inward_normal_vector
    );
    logic [ PADDLE_COUNT - 1 : 0 ]   hit;
    logic found [ 0 : PADDLE_COUNT - 1 ]; 
    always_comb begin
        next_ball_velocity = current_ball_velocity;
        hit[0] = (( '0              < in_theta_dir[0])                                                                          
            &&  (   in_theta_dir[0] < upper_bound_in_theta_dir[0])                                                              
            &&  (   '0              < in_phi_dir[0])                                                                            
            &&  (   in_phi_dir[0]   < upper_bound_in_phi_dir[0])                                                                
            &&  (-(ball.radius + PADDLE_HALF_RADIUS_OFFSET) < ball_distance_from_paddle_center[0])  
            &&  ( ball_distance_from_paddle_center[0] < (ball.radius + PADDLE_HALF_RADIUS_OFFSET))
        );
        found[0] = hit[0];
        for (int i = 1; i < PADDLE_COUNT; i++) begin
            hit[i] = (( '0              < in_theta_dir[i])                                                                          
                &&  (   in_theta_dir[i] < upper_bound_in_theta_dir[i])                                                              
                &&  (   '0              < in_phi_dir[0])                                                                            
                &&  (   in_phi_dir[0]   < upper_bound_in_phi_dir[0])                                                                
                &&  (-(ball.radius + PADDLE_HALF_RADIUS_OFFSET) < ball_distance_from_paddle_center[0])  
                &&  ( ball_distance_from_paddle_center[0] < (ball.radius + PADDLE_HALF_RADIUS_OFFSET))
                &&  ~found[i-1] // TODO: this collision resolution may not meet timing, maybe think of another way
            );
            found[i] = hit[i] | found[i-1]; // TODO: check if this meets timing
        end
        // TODO: INVESTIGATE: what does the bellow code synthesize too, is it a chain of muxes ?
        // given that each is independent of the others, I'd imagine it'd synthesize as parallel muxes? Will look into this
        for (int i = 0; i < PADDLE_COUNT; i++) if (hit[i] == 1'b1) next_ball_velocity = trunc_add(current_ball_velocity, '{
                x: dist_t'((-2 * (inward_normal_vector[i].x ) * dot( inward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 2)),
                y: dist_t'((-2 * (inward_normal_vector[i].y ) * dot( inward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 2)),
                z: dist_t'((-2 * (inward_normal_vector[i].z ) * dot( inward_normal_vector[i] , current_ball_velocity )) >> ( 2*DIST_WIDTH - 2))
            });
    end
endmodule
