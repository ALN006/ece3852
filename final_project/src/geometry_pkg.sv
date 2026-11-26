/* verilator lint_off UNUSEDPARAM */
// ASSUMPTION: let (240, 240, 240) from the top left of the screen be the origin
package geometry_pkg;
    `include "sin_lut.svh"
    localparam  int                                         DIST_WIDTH  = 10;
    typedef     logic signed    [ DIST_WIDTH    - 1 : 0 ]   dist_t;     // typically but not neccesarily in pixels
    typedef     logic signed    [ 2*DIST_WIDTH  + 1 : 0 ]   dot_t;
    typedef     logic           [ ANGLE_WIDTH   - 1 : 0 ]   angle_t;
    typedef     logic signed    [ 2*DIST_WIDTH      : 0 ]   det_t;
    localparam  angle_t                                     HALF_PI     = angle_t'(1 << ( ANGLE_WIDTH-1 -2 ));
    localparam  angle_t                                     PI          = angle_t'(1 << ( ANGLE_WIDTH-1 -1 ));

    typedef struct {
        dist_t  x;
        dist_t  y;
    } cart_2d_coord_t;
    typedef struct {
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

    // TODO: check wether the bellow function meets timing and consider introducing a dot_t
    function automatic dot_t dot(cart_coord_t a, cart_coord_t b);
        return a.x * b.x + a.y * b.y + a.z * b.z;
    endfunction

    function automatic det_t det_2d(cart_2d_coord_t a, cart_2d_coord_t b);
        return a.x * b.y - a.y * b.x;
    endfunction
    
    typedef struct {
        dist_t  radius;
        angle_t theta;   
    } polar_2d_coord_t;
    typedef struct {
        dist_t  radius;
        angle_t phi; 
        angle_t theta;   
    } polar_coord_t;

    // TODO: make sure this meets timing
    function automatic cart_coord_t polar_to_cart(polar_coord_t a);
        return '{
            x: DIST_WIDTH'((SIN_AMP_BITS'(a.radius) * SIN_LUT[ a.phi ] * SIN_LUT [ a.theta + HALF_PI ]) >>> (2*(SIN_AMP_BITS - 2))),
            y: DIST_WIDTH'((SIN_AMP_BITS'(a.radius) * SIN_LUT[ a.phi ] * SIN_LUT [ a.theta ]) >>> (2*(SIN_AMP_BITS - 2))),
            z: DIST_WIDTH'((SIN_AMP_BITS'(a.radius) * SIN_LUT[ a.phi + HALF_PI ]) >>> (SIN_AMP_BITS - 2))
        };
    endfunction

    // TODO: experiment and see if these are reasonable values
    localparam angle_t  PADDLE_THETA_OFFSET         = ANGLE_WIDTH'(10);
    localparam angle_t  PADDLE_HALF_THETA_OFFSET    = ANGLE_WIDTH'(PADDLE_THETA_OFFSET >> 1);
    localparam angle_t  PADDLE_PHI_OFFSET           = ANGLE_WIDTH'(10);
    localparam angle_t  PADDLE_HALF_PHI_OFFSET      = ANGLE_WIDTH'(PADDLE_PHI_OFFSET >> 1);
    localparam dist_t   PADDLE_RADIUS_OFFSET        = DIST_WIDTH'(5);
    localparam dist_t   PADDLE_HALF_RADIUS_OFFSET   = DIST_WIDTH'(PADDLE_RADIUS_OFFSET >>> 1);

    typedef struct {
        cart_coord_t    center; 
        dist_t          radius; 
    } sphere_t; 
endpackage
