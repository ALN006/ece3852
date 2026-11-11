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

    typedef struct packed {
        point_3d_t                          v0;
        point_3d_t                          v1;
        logic       [ COORD_WIDTH - 1 : 0 ] width;
        logic       [ COORD_WIDTH - 1 : 0 ] height;
    } cuboid_t;

    typedef struct packed {
        point_2d_t                          center;
        logic       [ COORD_WIDTH - 1 : 0 ] radius;
    } circle_t;    

    typedef struct packed {
        point_3d_t                          center;
        logic       [ COORD_WIDTH - 1 : 0 ] radius;
    } sphere_t;
endpackage
