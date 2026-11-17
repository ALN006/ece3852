// TODO: complete module rewrite to actually handle collisions
// TODO: better names
// TODO: better types
// TODO: better work efficiency
// TODO: better logic
module collision_handler // TODO: confirm that this module meets timing and consider what to do when a module such as this doesnt meet timing (pipeline or slower clock or other)
    import our_logic_pkg::*;
    #(  parameter   int                                     PADDLE_COUNT                                                    = 2 )(
        input       paddle_t                                paddles                             [ 0 : PADDLE_COUNT - 1 ],
        input       sphere_t                                ball,
        output      logic                                   is_collision                        [ 0 : PADDLE_COUNT - 1 ],
        output      cart_coord_t                            outward_normal_vector               [ 0 : PADDLE_COUNT - 1 ],
        output      logic signed [ 2*DIST_WIDTH + 1 : 0 ]   ball_distance_from_paddle_center    [ 0 : PADDLE_COUNT - 1 ] // TODO: look into making a dot_t, packed dimension here looks random
    );
    cart_coord_t v                      [ 0 : PADDLE_COUNT - 1 ]; 
    cart_coord_t theta_offset_vector    [ 0 : PADDLE_COUNT - 1 ];
    cart_coord_t phi_offset_vector      [ 0 : PADDLE_COUNT - 1 ]; 
    cart_coord_t ball_offset_v          [ 0 : PADDLE_COUNT - 1 ];

    logic signed [ 2*DIST_WIDTH + 1 : 0 ]   d1  [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*DIST_WIDTH + 1 : 0 ]   d2  [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ DIST_WIDTH - 1 : 0 ]     half_r_offset   [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ DIST_WIDTH     : 0 ]     r_sum           [ 0 : PADDLE_COUNT - 1 ];
    logic signed [ 2*DIST_WIDTH + 1 : 0 ]   dist_bound      [ 0 : PADDLE_COUNT - 1 ];
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin
        v[i] = polar_to_cart(paddles[i].v);

        outward_normal_vector[i]            = polar_to_cart('{
            radius: paddles[i].radius_offset,
            theta:  paddles[i].v.theta  + (paddles[i].theta_offset  >> 1),
            phi:    paddles[i].v.phi    + (paddles[i].phi_offset    >> 1)
        });
        theta_offset_vector[i]              = trunc_sub(polar_to_cart('{  
            radius: paddles[i].v.radius,
            theta:  paddles[i].v.theta + paddles[i].theta_offset,
            phi:    paddles[i].v.phi
        }), v[i]);
        phi_offset_vector[i]                = trunc_sub(polar_to_cart('{  
            radius: paddles[i].v.radius,
            theta:  paddles[i].v.theta,
            phi:    paddles[i].v.phi + paddles[i].phi_offset
        }), v[i]);

        half_r_offset[i] = paddles[i].radius_offset >>> 1;
        r_sum[i]         = (DIST_WIDTH+1)'(ball.radius) + (DIST_WIDTH+1)'(half_r_offset[i]);
        dist_bound[i]    = (2*DIST_WIDTH+2)'(r_sum[i]) * (2*DIST_WIDTH+2)'(paddles[i].radius_offset);
        ball_distance_from_paddle_center[i] = dot(trunc_sub( ball.center, polar_to_cart('{
            radius: paddles[i].v.radius + half_r_offset[i],
            theta:  paddles[i].v.theta  + (paddles[i].theta_offset  >> 1),
            phi:    paddles[i].v.phi    + (paddles[i].phi_offset    >> 1)
        })), outward_normal_vector[i]);
        
        ball_offset_v[i] = trunc_sub(ball.center, v[i]);
        d1[i] = dot(theta_offset_vector[i],    ball_offset_v[i]);
        d2[i] = dot(phi_offset_vector[i],      ball_offset_v[i]);
        
        is_collision[i] = (
            ( '0 < d1[i] ) && (  d1[i] < dot(theta_offset_vector[i], theta_offset_vector[i])) && 
            ( '0 < d2[i] ) && (  d2[i] < dot(phi_offset_vector[i],   phi_offset_vector[i])) &&
            ( -dist_bound[i] * paddles[i].radius_offset < ball_distance_from_paddle_center[i] ) && 
            ( ball_distance_from_paddle_center[i]  < dist_bound[i] )
        );
    end
endmodule
