/* verilator lint_off UNUSEDSIGNAL */   // TODO: implement this module
module frame_gen_for_3d_polar_pong #(   // TODO: there is a small chance that this and the onther module name are too long, confirm
    parameter int MAX_SIMULTAENEOUS_KEYCODES    = 6, 
    parameter int KEYCODE_BITS                  = 8,
    parameter int ADDRESS_BITS                  = 8,    
    parameter int COLOR_BITS                    = 4,
    parameter int COORD_BITS                    = 10,
    parameter int MAX_OBJS_ON_SCREEN            = 13 
)(
    input   logic                                   clk,
    input   logic                                   draw_now,
    input   logic [ KEYCODE_BITS        - 1 : 0 ]   keycodes        [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1 ],
    
    output  logic [ ADDRESS_BITS        - 1 : 0 ]   write_addresses [ 0 : MAX_OBJS_ON_SCREEN            - 1 ],
    output  logic [ 3 * COLOR_BITS      - 1 : 0 ]   write_data      [ 0 : MAX_OBJS_ON_SCREEN            - 1 ], 
    output  logic [ COORD_BITS          - 1 : 0 ]   obj_coords      [ 0 : 4*MAX_OBJS_ON_SCREEN          - 1 ]
);
    assign  write_addresses = '{ MAX_OBJS_ON_SCREEN     { {(ADDRESS_BITS    + 1)/2  {2'b10}} } };
    assign  write_data      = '{ MAX_OBJS_ON_SCREEN     { {(3 * COLOR_BITS  + 1)/2  {2'b10}} } };
    assign  obj_coords      = '{ 4 * MAX_OBJS_ON_SCREEN { {(COORD_BITS      + 1)/2  {2'b10}} } };
endmodule
