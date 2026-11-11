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
    logic [ `address_bits   - 1 : 0 ] read_addresses    [ 0 : `max_objs_on_screen ];
    occlusion_handling_color_mapper draw_logic (   // TODO: implement this to handle occlusion
        .pix_clk,           // TODO: consider passing in faster clock
        .draw_now,
        .read_data,
        .obj_coords,

        .read_addresses,
        .red, .green, .blue 
    ); 

    logic [ (3 * `color_bits) - 1 : 0 ] read_data [ 0 : `max_objs_on_screen    - 1 ]; // rgb color
    memory per_object_pixel_color_storage [`max_objs_on_screen - 1:0] ( // TODO: implement this to store sprites without considering occlussion
        .clk, 
        .enable (~draw_now),
        .address((draw_now) ? read_addresses : write_addresses),
        .write_data,

        .read_data
    );
    
    logic [ `address_bits       - 1 : 0 ] write_addresses   [ 0 : `max_objs_on_screen ];
    logic [ (3 * `color_bits)   - 1 : 0 ] write_data        [ 0 : `max_objs_on_screen ]; // rgb color
    logic [ `coord_bits         - 1 : 0 ] obj_coords        [ 0 : (4 * `max_objs_on_screen) - 1 ]; // 3d + span
    frame_gen_for_3d_polar_pong frame_gen_logic (   // TODO: implement everything but occlusion handling here 
        .clk,
        .draw_now,
        .keycodes,
        
        .write_addresses,
        .write_data,
        .obj_coords
    );
endmodule
