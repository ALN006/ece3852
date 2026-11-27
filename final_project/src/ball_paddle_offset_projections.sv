// TODO: HIGH PRIORITY: check if this module meets timing
// TODO: HIGH PRIORITY: check if this module works correctly
// TODO: LOW PRIORITY: consider work efficiency of this module
module ball_paddle_offset_projections
    import geometry_pkg::*;
    #(  parameter   int             PADDLE_COUNT                                                    = 2 )(   
        input       polar_coord_t   paddles                             [ 0 : PADDLE_COUNT - 1 ],
        input       sphere_t        ball                                                        ,
        output      dot_t           in_theta_dir                        [ 0 : PADDLE_COUNT - 1 ],
        output      dot_t           upper_bound_in_theta_dir            [ 0 : PADDLE_COUNT - 1 ],
        output      dot_t           in_phi_dir                          [ 0 : PADDLE_COUNT - 1 ],
        output      dot_t           upper_bound_in_phi_dir              [ 0 : PADDLE_COUNT - 1 ],
        output      dist_t          ball_distance_from_paddle_center    [ 0 : PADDLE_COUNT - 1 ],
        output      cart_coord_t    inward_normal_vector                [ 0 : PADDLE_COUNT - 1 ]
    );
    cart_coord_t    paddles_in_cart     [ 0 : PADDLE_COUNT - 1 ];
    cart_coord_t    theta_offset_vector [ 0 : PADDLE_COUNT - 1 ];
    cart_coord_t    phi_offset_vector   [ 0 : PADDLE_COUNT - 1 ];
    cart_coord_t    ball_offset_vector  [ 0 : PADDLE_COUNT - 1 ];
    always_comb for (int i = 0; i < PADDLE_COUNT; i++) begin
        paddles_in_cart[i]      = polar_to_cart(paddles[i]);
        inward_normal_vector[i] = polar_to_cart('{
                radius: dist_t'(1 << (DIST_WIDTH - 1)),
                theta:  paddles[i].theta    + PADDLE_HALF_THETA_OFFSET,
                phi:    paddles[i].phi      + PADDLE_HALF_PHI_OFFSET
            });
        theta_offset_vector[i]  = trunc_sub(polar_to_cart('{
                    radius: paddles[i].radius,
                    theta:  paddles[i].theta + PADDLE_THETA_OFFSET,
                    phi:    paddles[i].phi
                }),
            paddles_in_cart[i]
        );
        phi_offset_vector[i] = trunc_sub(polar_to_cart('{
                    radius: paddles[i].radius,
                    theta:  paddles[i].theta,
                    phi:    paddles[i].phi + PADDLE_PHI_OFFSET
                }),
            paddles_in_cart[i]
        );
        // TODO: the 2 lines bellow look super unmotivated and ugly, change that
        PADDLE_THETA_RADIUS_FIX = DIST_WIDTH'((SIN_AMP_BITS'(2*paddles[i].radius) * SIN_LUT[ PADDLE_HALF_THETA_OFFSET ] * SIN_LUT [ PADDLE_HALF_THETA_OFFSET >> 1 ]) >> (2*(SIN_AMP_BITS - 2)));
        PADDLE_PHI_RADIUS_FIX = DIST_WIDTH'((SIN_AMP_BITS'(2*paddles[i].radius) * SIN_LUT[ PADDLE_HALF_PHI_OFFSET ] * SIN_LUT [ PADDLE_HALF_PHI_OFFSET >> 1 ]) >> (2*(SIN_AMP_BITS - 2)));
        ball_distance_from_paddle_center[i] = dist_t'(
            dot(
                trunc_sub(
                    ball.center,
                    polar_to_cart('{ //TODO: CONSIDER: this need not be the center of our frustum, its an approximation that breaks with bigger angles
                            // DIST_WIDTH'((SIN_AMP_BITS'(2*paddles[i].radius) * SIN_LUT[ PADDLE_HALF_THETA_OFFSET ] * SIN_LUT [ PADDLE_HALF_THETA_OFFSET >> 1 ]) >> (2*(SIN_AMP_BITS - 2)))
                            radius: paddles[i].radius   + PADDLE_HALF_RADIUS_OFFSET - PADDLE_THETA_RADIUS_FIX - PADDLE_PHI_RADIUS_FIX,
                            theta:  paddles[i].theta    + PADDLE_HALF_THETA_OFFSET,
                            phi:    paddles[i].phi      + PADDLE_HALF_PHI_OFFSET
                        })),
                inward_normal_vector[i]
            ) >> (DIST_WIDTH -1)
        );
        ball_offset_vector[i]       = trunc_sub(ball.center,        paddles_in_cart[i]);
        in_theta_dir[i]             = dot(theta_offset_vector[i],   ball_offset_vector[i]);
        upper_bound_in_theta_dir[i] = dot(theta_offset_vector[i],   theta_offset_vector[i]);
        in_phi_dir[i]               = dot(phi_offset_vector[i],     ball_offset_vector[i]);
        upper_bound_in_phi_dir[i]   = dot(phi_offset_vector[i],     phi_offset_vector[i]);
    end
endmodule
