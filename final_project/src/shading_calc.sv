import our_logic_pkg::*; // TODO: remeber to have a conversation about not doing this with nick

// take in the 100% lit up color, then desaturate as needed depending on light reflections
// TODO: pedantically ask nick to define desaturation, and use the dot product module

module shading_calc #(
    parameter int COLOR_BITS            = 4,
    parameter int COORD_BITS            = 14
)(
    input logic ambient_hue,
    input our_logic_pkg::cart_coord_t beam_origin,
    input our_logic_pkg::cart_coord_t reflect_point,
    input our_logic_pkg::cart_coord_t normal_vector, // Use the xyz of cart_coord to pass vector data
    input logic [COLOR_BITS - 1:0] red, green, blue,

    output logic [COLOR_BITS - 1:0] shaded_red, shaded_green, shaded_blue
);

    integer dot_product;
    logic signed [31:0] normalized_dot_product;
    logic signed [31:0] normal_mag;
    logic [15:0] overall_mag;
    logic waiting_for_shift;
    logic [31:0] red_shader_made, green_shader_made, blue_shader_made;

    our_logic_pkg::cart_coord_t beam_vector;
    assign normal_mag = ((normal_vector.x)**2 + (normal_vector.y)**2 + (normal_vector.z)**2);

    always_comb begin
        waiting_for_shift = 1'b1;
        normalized_dot_product = '0;
        
        beam_vector.x = beam_origin.x - reflect_point.x;
        beam_vector.y = beam_origin.y - reflect_point.y;
        beam_vector.z = beam_origin.z - reflect_point.z;
        dot_product = beam_vector.x*normal_vector.x + beam_vector.y*normal_vector.y + beam_vector.z*normal_vector.z;
        // approximate division, 32-bit true division in a 40ns clock period would be tricky
        if (dot_product > 0) begin
            for (int i = 15; i >= 0; i--) begin
                if (overall_mag[i] & waiting_for_shift) begin // the 6 taken off the left shift is there to account for dividing by radius = 64
                    normalized_dot_product = ((dot_product)<<(10-6))>>i;
                    waiting_for_shift = 1'b0;
                end
            end            
            // normalized_dot_product = ((dot_product)<<10) / overall_mag;
        end
        if (ambient_hue) begin
            red_shader_made = (((red * normalized_dot_product) >> 10) > 16'h1) ? ((red * normalized_dot_product) >> 10) : 16'h1;
            shaded_red = (red_shader_made > 15) ? 4'hF : red_shader_made[3:0];
            
            green_shader_made = (((green * normalized_dot_product) >> 10) > 16'h1) ? ((green * normalized_dot_product) >> 10) : 16'h1;
            shaded_green = (green_shader_made > 15) ? 4'hF : green_shader_made[3:0];

            blue_shader_made = (((blue * normalized_dot_product) >> 10) > 16'h1) ? ((blue * normalized_dot_product) >> 10) : 16'h1;
            shaded_blue = (blue_shader_made > 15) ? 4'hF : blue_shader_made[3:0];
        
        end else begin
            {shaded_red, shaded_green, shaded_blue} = '0;
        end
    end

sqrt square_root_shader (
    .square(((beam_vector.x)**2 + (beam_vector.y)**2 + (beam_vector.z)**2)),
    .result(overall_mag)
);

endmodule