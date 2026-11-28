/* verilator lint_off UNUSEDPARAM */
// ASSUMPTION: let (240, 240, 240) from the top left of the screen be the origin
package geometry_pkg;
    `include "distances_def.svh"
    typedef struct packed { // TODO: go ask prof cheng what packed means anyway
        dist_t  x;
        dist_t  y;
    } cart_coord_2d_t;
    typedef struct packed {
        dist_t   x;
        dist_t   y;
        dist_t   z;
    } cart_coord_t;

    function automatic cart_coord_t trunc_add(cart_coord_t a, cart_coord_t b);
        return '{x: DIST_WIDTH'(a.x + b.x), y: DIST_WIDTH'(a.y + b.y), z: DIST_WIDTH'(a.z + b.z) };
    endfunction

    function automatic cart_coord_t trunc_sub(cart_coord_t a, cart_coord_t b);
        return '{x: DIST_WIDTH'(a.x - b.x), y: DIST_WIDTH'(a.y - b.y), z: DIST_WIDTH'(a.z - b.z) };
    endfunction

    function automatic cart_coord_2d_t trunc_add_2d(cart_coord_2d_t a, cart_coord_2d_t b);
        return '{x: DIST_WIDTH'(a.x + b.x), y: DIST_WIDTH'(a.y + b.y)};
    endfunction

    function automatic cart_coord_2d_t trunc_sub_2d(cart_coord_2d_t a, cart_coord_2d_t b);
        return '{x: DIST_WIDTH'(a.x - b.x), y: DIST_WIDTH'(a.y - b.y)};
    endfunction

    // TODO: check wether the bellow function meets timing and consider introducing a dot_t
    function automatic dot_t dot(cart_coord_t a, cart_coord_t b);
        return a.x * b.x + a.y * b.y + a.z * b.z;
    endfunction

    function automatic det_t det_2d(cart_coord_2d_t a, cart_coord_2d_t b);
        return a.x * b.y - a.y * b.x;
    endfunction
    
    typedef struct {
        dist_t  radius;
        angle_t phi; 
        angle_t theta;   
    } polar_coord_t;

    function automatic cart_coord_t polar_to_cart(polar_coord_t a);
        return '{
            x: cosp(.angle(a.theta), .distance(sinp( .angle(a.phi), .distance(a.radius)))),
            y: sinp(.angle(a.theta), .distance(sinp( .angle(a.phi), .distance(a.radius)))),
            z: cosp(.angle(a.phi), .distance(a.radius))
        };
    endfunction

    // TODO: experiment and see if these are reasonable values
    localparam angle_t  PADDLE_THETA_OFFSET         = ANGLE_WIDTH'(10);
    localparam angle_t  PADDLE_HALF_THETA_OFFSET    = ANGLE_WIDTH'(PADDLE_THETA_OFFSET >> 1);
    localparam angle_t  PADDLE_PHI_OFFSET           = ANGLE_WIDTH'(10);
    localparam angle_t  PADDLE_HALF_PHI_OFFSET      = ANGLE_WIDTH'(PADDLE_PHI_OFFSET >> 1);
    localparam dist_t   PADDLE_RADIUS_OFFSET        = DIST_WIDTH'(5);
    localparam dist_t   PADDLE_HALF_RADIUS_OFFSET   = DIST_WIDTH'(PADDLE_RADIUS_OFFSET >>> 1);

    typedef struct packed {
        cart_coord_t    center; 
        dist_t          radius; 
    } sphere_t; 
endpackage
