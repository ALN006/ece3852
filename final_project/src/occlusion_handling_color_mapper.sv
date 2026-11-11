/* verilator lint_off UNUSEDSIGNAL */ // TODO: actually implement this module
module occlusion_handling_color_mapper #(
    parameter ADDRESS_BITS          = 8,    
    parameter COLOR_BITS            = 4,
    parameter COORD_BITS            = 10,
    parameter MAX_OBJS_ON_SCREEN    = 13
)(
    input   logic                                   pix_clk,
    input   logic                                   draw_now,
    input   logic [ (3 * COORD_BITS)    - 1 : 0 ]   read_data           [ 0 : MAX_OBJS_ON_SCREEN    - 1 ],
    input   logic [ COORD_BITS          - 1 : 0 ]   obj_coords          [ 0 : 4*MAX_OBJS_ON_SCREEN  - 1 ],

    output  logic [ ADDRESS_BITS        - 1 : 0 ]   read_addresses      [ 0 : MAX_OBJS_ON_SCREEN    - 1 ], 
    output  logic [ COLOR_BITS          - 1 : 0 ]   red, green, blue
);
    assign  read_addresses       = '{ MAX_OBJS_ON_SCREEN { {(ADDRESS_BITS + 1)/2 {2'b10}} } };
    assign  {red, green, blue}   = { (3 * COLOR_BITS)/2 {2'b10}};
endmodule
