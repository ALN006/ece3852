// TODO: consider using unpacked structs 
package our_logic_types_pkg;
    localparam int COORD_WIDTH = 11;

    // TODO: figure out which of these abstractions to actually use
    typedef struct packed {
        logic signed [ COORD_WIDTH - 1 : 0 ]   x;
        logic signed [ COORD_WIDTH - 1 : 0 ]   y;        
    } point_2d_t;

    typedef struct packed {
        logic signed [ COORD_WIDTH - 1 : 0 ]   x;
        logic signed [ COORD_WIDTH - 1 : 0 ]   y;
        logic signed [ COORD_WIDTH - 1 : 0 ]   z;
    } point_3d_t;

    // TODO: check syntax here
    function automatic point_3d_t trunc_add(point_3d_t a, point_3d_t b);
        trunc_add.x = COORD_WIDTH'(a.x + b.x);
        trunc_add.y = COORD_WIDTH'(a.y + b.y);
        trunc_add.z = COORD_WIDTH'(a.z + b.z);
    endfunction

    function automatic point_3d_t trunc_sub(point_3d_t a, point_3d_t b);
        trunc_sub.x = COORD_WIDTH'(a.x - b.x);
        trunc_sub.y = COORD_WIDTH'(a.y - b.y);
        trunc_sub.z = COORD_WIDTH'(a.z - b.z);
    endfunction

    // TODO: check wether the bellow function meets timing
    function automatic logic signed [ 2*COORD_WIDTH + 1 : 0 ] dot(point_3d_t a, point_3d_t b);
        dot = a.x * b.x + a.y * b.y + a.z * b.z;
    endfunction

    typedef struct packed {
        point_2d_t  v0;
        point_2d_t  v1;
        point_2d_t  v2;
    } triangle_2d_t;

    typedef struct packed {
        point_3d_t  v0;
        point_3d_t  v1;
        point_3d_t  v2;
    } triangle_3d_t;

// (V1 - V0)x((V2 - V0)x(V3 - V0)) = 0
// V2 = V0 + height
// V3 = V0 + width
// v0 and v1 WILL DEFINE THE ANGLE
    typedef struct packed { // A & B define a line along the cuboid, length and width define the other orthogonal dimensions
        point_3d_t                          v0;
        point_3d_t                          v1;
        point_3d_t                          v2; // just use a third point, helps make rounding errors smaller
        logic signed       [ COORD_WIDTH - 1 : 0 ] height;
    } cuboid_t; // 100 bits

    typedef struct packed {
        point_2d_t                          center;
        logic signed       [ COORD_WIDTH - 1 : 0 ] radius;
    } circle_t;    

    typedef struct packed {
        point_3d_t                          center; // COORD_WIDTH * 3 bits (30 bits total)
        logic signed       [ COORD_WIDTH - 1 : 0 ] radius; // COORD_WIDTH bits (10 bits total)
    } sphere_t; // 40 bits
endpackage
