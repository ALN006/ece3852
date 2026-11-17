import our_logic_types_pkg::*; // TODO: remeber to have a conversation about not doing this with nick

// take in the 100% lit up color, then desaturate as needed depending on light reflections
// TODO: pedantically ask nick to define desaturation, and use the dot product module

module shading_calc #(
    parameter int COLOR_BITS            = 4,
    parameter int COORD_BITS            = 10,
)(
    input our_logic_types_pkg::cart_coord_t beam_origin,
    input our_logic_types_pkg::cart_coord_t reflect_point,
    input our_logic_types_pkg::cart_coord_t normal_vector, // Use the xyz of cart_coord to pass vector data
    input logic [COLOR_BITS - 1:0] red, green, blue,

    output logic [COLOR_BITS - 1:0] shaded_red, shaded_green, shaded_blue
);

    integer dot_product;
    logic [31:0] normalized_dot_product;
    our_logic_types_pkg::cart_coord_t beam_vector;

    always_comb begin
        beam_vector.x = reflect_point.x - beam_origin.x;
        beam_vector.y = reflect_point.y - beam_origin.y;
        beam_vector.z = reflect_point.z - beam_origin.z;
        dot_product = beam_vector.x*normal_vector.x + beam_vector.y*normal_vector.y + beam_vector.z*normal_vector.z;
        // NOTE: scale up by 1024 to keep the system as an integer. Normalizing around 1 won't work without decimal numbers
        normalized_dot_product = (11'd1024*dot_product) / (((beam_vector.x)**2 + (beam_vector.y)**2 + (beam_vector.z)**2)*((normal_vector.x)**2 + (normal_vector.y)**2 + (normal_vector.z)**2));
        // I'm aware division is computationally expensive, but I don't see how else to do shading
        shaded_red = (red * normalized_dot_product) / 11'd1024;
        shaded_green = (green * normalized_dot_product) / 11'd1024;
        shaded_blue = (blue * normalized_dot_product) / 11'd1024;
    end

endmodule