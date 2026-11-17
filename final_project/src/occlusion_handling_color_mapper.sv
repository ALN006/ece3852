import our_logic_types_pkg::*;
`define SPHERE_DEMO

module occlusion_handling_color_mapper (
    parameter int ADDRESS_BITS          = 8,    
    parameter int COLOR_BITS            = 4,
    parameter int COORD_BITS            = 10,
    parameter int MAX_OBJS_ON_SCREEN    = 13,
    parameter int PADDLE_COUNT          = 2,
)(
    input   logic                                   pix_clk,
    // input   logic                                   draw_now,
    input   logic [ 3 * COLOR_BITS      - 1 : 0 ]   read_data           [ 0 : MAX_OBJS_ON_SCREEN    - 1 ],
    // input   logic [ COORD_BITS          - 1 : 0 ]   obj_coords          [ 0 : 4*MAX_OBJS_ON_SCREEN  - 1 ],
    input   logic [ COORD_BITS          - 1 : 0 ]   drawX, drawY,
    input   our_logic_types_pkg::sphere_t           ball,
    input   our_logic_types_pkg::cuboid_t           paddles             [ 0 : PADDLE_COUNT          - 1 ],

    output  logic [ ADDRESS_BITS        - 1 : 0 ]   read_addresses      [ 0 : MAX_OBJS_ON_SCREEN    - 1 ], 
    output  logic [ COLOR_BITS          - 1 : 0 ]   red, green, blue
);


`ifdef SPHERE_DEMO
    our_logic_types_pkg::sphere_t demo_sphere;
    our_logic_types_pkg::cart_coord_t beam_origin;
    logic signed [COORD_BITS - 1:0] drawX_signed, drawY_signed;


    assign demo_sphere.center.x = 320;
    assign demo_sphere.center.y = 240;
    assign demo_sphere.center.z = 100;
    assign demo_sphere.radius = 50;
    assign beam_origin.x = 0;
    assign beam_origin.y = 0;
    assign beam_origin.z = 20;  
    
    logic signed [COORD_BITS - 1:0] perim_z_coord;
    our_logic_types_pkg::cart_coord_t reflect_point;
    our_logic_types_pkg::cart_coord_t normal_vector;
    logic [3:0] shader_red, shader_green, shader_blue;


    always_ff begin
        drawX_signed <= $signed(drawX);
        drawY_signed <= $signed(drawY);

    // check that our VGA coordinate is within the sphere's circle
        
        if (((drawX_signed - demo_sphere.center.x)**2 + (drawY_signed - demo_sphere.center.y)**2) < demo_sphere.radius**2) begin // 2D pythagorean theorem, are we within bounds of the circle?
            perim_z_coord <= $sqrt((demo_sphere.radius)**2 - (drawX_signed - demo_sphere.center.x)**2 - (drawY_signed - demo_sphere.center.y)**2); // 3D pythagorean theorem to determine Z-offset from the center's z-coordinate
            absolute_z_coord <= demo_sphere.center.z - perim_z_coord; // convert that offset to a Z coordinate referenced to the general space
            // The light bounce is in the pixel we're drawing, and the z-coordinate in absolute space
            reflect_point.x <= drawX;
            reflect_point.y <= drawY;
            reflect_point.z <= absolute_z_coord;
            // our normal vector runs from the center of the sphere to our point
            normal_vector.x <= drawX_signed - demo_sphere.center.x;
            normal_vector.y <= drawY_signed - demo_sphere.center.y;
            normal_vector.z <=  0 - perim_z_coord; // Assuming positive Z is into the screen, we need the vector to be biased out towards the screen
            {shader_red, shader_green, shader_blue} = 12'hF;
        end else begin
            {shader_red, shader_green, shader_blue} = 12'h0;
        end
    end
`endif

shading_calc shader (
    .beam_origin,
    .reflect_point,
    .normal_vector,
    .red(shader_red), .green(shader_green), .blue(shader_blue),

    .shaded_red(red), .shaded_green(green), .shaded_blue(blue)
);

endmodule