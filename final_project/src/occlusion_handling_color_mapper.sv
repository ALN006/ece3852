import our_logic_pkg::*;
// `include "sin_lut.svh"

`define SPHERE_DEMO

module occlusion_handling_color_mapper #(
    parameter int ADDRESS_BITS          = 8,    
    parameter int COLOR_BITS            = 4,
    parameter int COORD_BITS            = 14,
    parameter int MAX_OBJS_ON_SCREEN    = 13,
    parameter int PADDLE_COUNT          = 2
)(
    input   logic                                   pix_clk,
    input   logic                                   speed_clk,
    // input   logic                                   draw_now,
    // input   logic [ 3 * COLOR_BITS      - 1 : 0 ]   read_data           [ 0 : MAX_OBJS_ON_SCREEN    - 1 ],
    // input   logic [ COORD_BITS          - 1 : 0 ]   obj_coords          [ 0 : 4*MAX_OBJS_ON_SCREEN  - 1 ],
    input   logic [ COORD_BITS          - 1 : 0 ]   drawX, drawY,
    // input   our_logic_types_pkg::sphere_t           ball,

    // output  logic [ ADDRESS_BITS        - 1 : 0 ]   read_addresses      [ 0 : MAX_OBJS_ON_SCREEN    - 1 ], 
    output  logic [ COLOR_BITS          - 1 : 0 ]   red, green, blue
);

    our_logic_pkg::sphere_t demo_sphere;
    our_logic_pkg::cart_coord_t beam_origin;
    logic signed [2*COORD_BITS - 1:0] drawX_signed, drawY_signed; // allow for squaring w/o sign errors

    logic signed [COORD_BITS - 1:0] perim_z_coord;
    logic signed [COORD_BITS - 1:0] absolute_z_coord;
    our_logic_pkg::cart_coord_t reflect_point;
    our_logic_pkg::cart_coord_t normal_vector;
    logic [3:0] shader_red, shader_green, shader_blue;
    logic inside_sphere;
    logic ambient_hue;

`ifdef SPHERE_DEMO

    assign demo_sphere.center.x = 320;
    assign demo_sphere.center.y = 240;
    assign demo_sphere.center.z = 100;
    assign demo_sphere.radius = 64;
    assign beam_origin.x = 0;
    assign beam_origin.y = 0;
    assign beam_origin.z = 20;  

    always_comb begin
        drawX_signed = 20'($signed({1'b0, drawX}));
        drawY_signed = 20'($signed({1'b0, drawY}));
        absolute_z_coord = demo_sphere.center.z - perim_z_coord; 
    end
    // check that our VGA coordinate is within the sphere's circle
    always_ff @(posedge pix_clk) begin    
        if (((drawX_signed - demo_sphere.center.x)**2 + (drawY_signed - demo_sphere.center.y)**2) < demo_sphere.radius**2) begin // 2D pythagorean theorem, are we within bounds of the circle?
            ambient_hue <= 1'b1;
            // perim_z_coord <= $sqrt((demo_sphere.radius)**2 - (drawX_signed - demo_sphere.center.x)**2 - (drawY_signed - demo_sphere.center.y)**2); // 3D pythagorean theorem to determine Z-offset from the center's z-coordinate
            // NOTE: above is now implemented using square root module
            
            // convert that offset to a Z coordinate referenced to the general space
            
            // The light bounce is in the pixel we're drawing, and the z-coordinate in absolute space
            reflect_point.x <= drawX;
            reflect_point.y <= drawY;
            reflect_point.z <= absolute_z_coord;
            
            // our normal vector runs from the center of the sphere to our point
            normal_vector.x <= drawX_signed - demo_sphere.center.x;
            normal_vector.y <= drawY_signed - demo_sphere.center.y;
            normal_vector.z <=  0 - perim_z_coord; // Assuming positive Z is into the screen, we need the vector to be biased out towards the screen
            
            {shader_red, shader_green, shader_blue} <= 12'hFFF;
        end else begin
            ambient_hue <= 1'b0;
            {shader_red, shader_green, shader_blue} <= 12'h0;
        end
    end
`endif

shading_calc shader (
    .ambient_hue,
    .beam_origin,
    .reflect_point,
    .normal_vector,
    .red(shader_red), .green(shader_green), .blue(shader_blue),

    .shaded_red(red), .shaded_green(green), .shaded_blue(blue)
);

sqrt square_root (
    .clk(speed_clk),
    .square((demo_sphere.radius)**2 - (drawX_signed - demo_sphere.center.x)**2 - (drawY_signed - demo_sphere.center.y)**2),
    .result(perim_z_coord)
);

endmodule