// TODO: consider using unpacked structs 
// ASSUMPTION: let (240, 240, 240) from the top left of the screen be the origin
package our_logic_pkg;
    `include "sin_lut.svh"
    localparam int DIST_WIDTH   = 10;

    // TODO: figure out which of these abstractions to actually use
    typedef struct {
        logic signed [ DIST_WIDTH - 1 : 0 ]   x;
        logic signed [ DIST_WIDTH - 1 : 0 ]   y;
        logic signed [ DIST_WIDTH - 1 : 0 ]   z;
    } cart_coord_t;
    function automatic cart_coord_t trunc_add(cart_coord_t a, cart_coord_t b);
        return '{x: DIST_WIDTH'(a.x + b.x), y: DIST_WIDTH'(a.y + b.y), z: DIST_WIDTH'(a.z + b.z) };
    endfunction

    function automatic cart_coord_t trunc_sub(cart_coord_t a, cart_coord_t b);
        return '{x: DIST_WIDTH'(a.x - b.x), y: DIST_WIDTH'(a.y - b.y), z: DIST_WIDTH'(a.z - b.z) };
    endfunction

    // TODO: check wether the bellow function meets timing and consider introducing a dot_t
    function automatic logic signed [ 2*DIST_WIDTH + 1 : 0 ] dot(cart_coord_t a, cart_coord_t b);
        return a.x * b.x + a.y * b.y + a.z * b.z;
    endfunction

    typedef struct {
        logic signed    [ DIST_WIDTH    - 1 : 0 ]   radius;
        logic           [ ANGLE_WIDTH   - 1 : 0 ]   phi; 
        logic           [ ANGLE_WIDTH   - 1 : 0 ]   theta;   
    } polar_coord_t;

    // TODO: make sure this meets timing
    function automatic cart_coord_t polar_to_cart(polar_coord_t a);
        return '{
            x: DIST_WIDTH'((SIN_AMP_BITS'(a.radius) * SIN_LUT[ a.phi ] * SIN_LUT [ a.theta + 8'd64 ]) >> (2*(SIN_AMP_BITS - 2))),
            y: DIST_WIDTH'((SIN_AMP_BITS'(a.radius) * SIN_LUT[ a.phi ] * SIN_LUT [ a.theta ]) >> (2*(SIN_AMP_BITS - 2))),
            z: DIST_WIDTH'((SIN_AMP_BITS'(a.radius) * SIN_LUT[ a.phi + 8'd64 ]) >> (SIN_AMP_BITS - 2))
        };
    endfunction

    typedef struct { 
        polar_coord_t                               v; // front_top_right from the perspective of the rdius vector to it
        logic           [ ANGLE_WIDTH   - 1 : 0 ]   phi_offset;
        logic           [ ANGLE_WIDTH   - 1 : 0 ]   theta_offset;
        logic signed    [ DIST_WIDTH    - 1 : 0 ]   radius_offset;
    } paddle_t;   

    typedef struct {
        cart_coord_t                            center; 
        logic signed    [ DIST_WIDTH - 1 : 0 ]  radius; 
    } sphere_t; 
endpackage
