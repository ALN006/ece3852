// TODO: check if a macro is the most appropriate form for the vars bellow
`define max_objs_on_screen  13 
`define color_bits          4
`define coord_bits          10
`define address_bits        8

module our_logic #(
    parameter MAX_SIMULTAENEOUS_KEYCODES    = 6, // TODO: figure out what happens when you dont specify the type of a parameter
    parameter KEYCODE_BITS                  = 8
)(
    input   logic                               clk,
    input   logic                               pix_clk,
    input   logic                               draw_now,
    input   logic [ `coord_bits     - 1 : 0 ]   drawX, drawY,
    input   logic [ KEYCODE_BITS    - 1 : 0 ]   keycodes        [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1],

    output  logic [ `color_bits     - 1 : 0 ]   red, green, blue
);
    logic [ `address_bits   - 1 : 0 ] read_addresses    [ 0 : `max_objs_on_screen - 1 ];
    occlusion_handling_color_mapper #(
        .ADDRESS_BITS(address_bits),
        .COLOR_BITS(color_bits),
        .COORD_BITS(coord_bits),
        .MAX_OBJS_ON_SCREEN(max_objs_on_screen)  
    ) draw_logic (   // TODO: implement this to handle occlusion
        .pix_clk,           // TODO: consider passing in faster clock
        .draw_now,
        .read_data,
        .obj_coords,

        .read_addresses,
        .red, .green, .blue 
    ); 

    logic [ (3 * `color_bits) - 1 : 0 ] read_data [ 0 : `max_objs_on_screen    - 1 ]; // rgb color
    memory  [`max_objs_on_screen - 1:0] #(
        .ADDRESS_WIDTH(ADDRESS_BITS),
        .DATA_WIDTH(3 * `color_bits)
    ) per_object_pixel_color_storage ( // TODO: implement this to store sprites without considering occlussion
        .clk, 
        .enable (~draw_now),
        .address((draw_now) ? read_addresses : write_addresses),
        .write_data,

        .read_data
    );
    
    logic [ `address_bits       - 1 : 0 ] write_addresses   [ 0 : `max_objs_on_screen ];
    logic [ (3 * `color_bits)   - 1 : 0 ] write_data        [ 0 : `max_objs_on_screen ]; // rgb color
    logic [ `coord_bits         - 1 : 0 ] obj_coords        [ 0 : (4 * `max_objs_on_screen) - 1 ]; // 3d + span
    frame_gen_for_3d_polar_pong # (
        .ADDRESS_BITS(address_bits),
        .COLOR_BITS(color_bits),
        .COORD_BITS(coord_bits),
        .MAX_OBJS_ON_SCREEN(max_objs_on_screen)  
    ) frame_gen_logic (   // TODO: implement everything but occlusion handling here 
        .clk,
        .draw_now,
        .keycodes,
        
        .write_addresses,
        .write_data,
        .obj_coords
    );
endmodule
