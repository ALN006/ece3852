// TODO: consider using unpacked structs 
package our_logic_types_pkg;
    localparam COORD_WIDTH = our_logic_constants_pkg::COORD_WIDTH ;

    // TODO: figure out which of these abstractions to actually use
    typedef struct packed {
        logic [ COORD_WIDTH - 1 : 0 ]   x;
        logic [ COORD_WIDTH - 1 : 0 ]   y;        
    } point_2d_t;

    typedef struct packed {
        logic [ COORD_WIDTH - 1 : 0 ]   x;
        logic [ COORD_WIDTH - 1 : 0 ]   y;
        logic [ COORD_WIDTH - 1 : 0 ]   z;
    } point_3d_t;

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
        point_3d_t                          width_vector; // It uses a point_3d structure, but it should be interpreted as a VECTOR
        logic       [ COORD_WIDTH - 1 : 0 ] height;
    } cuboid_t; // 100 bits

    typedef struct packed {
        point_2d_t                          center;
        logic       [ COORD_WIDTH - 1 : 0 ] radius;
    } circle_t;    

    typedef struct packed {
        point_3d_t                          center; // COORD_WIDTH * 3 bits (30 bits total)
        logic       [ COORD_WIDTH - 1 : 0 ] radius; // COORD_WIDTH bits (10 bits total)
    } sphere_t; // 40 bits
endpackage
