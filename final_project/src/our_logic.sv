import our_logic_constants_pkg::*;

module our_logic #(
    parameter int MAX_SIMULTAENEOUS_KEYCODES    = 6, // TODO: figure out what happens when you dont specify the type of a parameter
    parameter int KEYCODE_WIDTH                 = 8 // Answer seems to be "synthesizer sets the type to that of whatever data it's receiving"
)(
    input   logic                               clk,
    input   logic                               pix_clk,
    input   logic                               draw_now,
    input   logic [ `coord_bits     - 1 : 0 ]   drawX, drawY,
    input   logic [ KEYCODE_WIDTH    - 1 : 0 ]   keycodes        [ 0 : MAX_SIMULTAENEOUS_KEYCODES    - 1],

    output  logic [ `color_bits     - 1 : 0 ]   red, green, blue
);
    logic [ `address_bits   - 1 : 0 ] read_addresses    [ 0 : `max_objs_on_screen - 1 ];
    occlusion_handling_color_mapper #(
        .ADDRESS_BITS(`address_bits),
        .COLOR_BITS(`color_bits),
        .COORD_BITS(`coord_bits),
        .MAX_OBJS_ON_SCREEN(`max_objs_on_screen)  
    ) draw_logic (   // TODO: implement this to handle occlusion
        .pix_clk,           // TODO: consider passing in faster clock
        .draw_now,
        .read_data,
        .obj_coords,
        .drawX, .drawY,

        .read_addresses,
        .red, .green, .blue 
    ); 

    logic [ (3 * `color_bits) - 1 : 0 ] read_data [ 0 : `max_objs_on_screen    - 1 ]; // rgb color
    memory #(
        .ADDRESS_WIDTH(`address_bits),
        .DATA_WIDTH(3 * `color_bits)
    ) per_object_pixel_color_storage [`max_objs_on_screen - 1:0] ( // TODO: implement this to store sprites without considering occlussion
        .clk,                                                       // seems to be done?
        .enable (~draw_now),
        .address((draw_now) ? read_addresses : write_addresses),
        .write_data,

        .read_data
    );
    
    logic [ `address_bits       - 1 : 0 ] write_addresses   [ 0 : `max_objs_on_screen - 1];
    logic [ (3 * `color_bits)   - 1 : 0 ] write_data        [ 0 : `max_objs_on_screen - 1]; // rgb color
    logic [ `coord_bits         - 1 : 0 ] obj_coords        [ 0 : (4 * `max_objs_on_screen) - 1 ]; // 3d + span
    frame_gen_for_3d_polar_pong # (
        .ADDRESS_BITS(`address_bits),
        .COLOR_BITS(`color_bits),
        .COORD_BITS(`coord_bihts),
        .MAX_OBJS_ON_SCREEN(`max_objs_on_screen)  
    ) frame_gen_logic (   // TODO: implement everything but occlusion handling here 
        .clk,
        .draw_now,
        .keycodes,
        
        .write_addresses,
        .write_data,
        .obj_coords
    );
endmodule
