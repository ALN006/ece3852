import our_logic_types_pkg::*;

module shading_calc #(
    parameter int COLOR_BITS            = 4,
    parameter int COORD_BITS            = 10,
)(
    input logic [COORD_BITS - 1:0] beam_origin,
    input logic [COORD_BITS - 1:0] reflect_point,
    input logic [COORD_BITS - 1:0] normal_vector [2:0],
    input logic [COLOR_BITS - 1:0] red, green, blue,

    output logic [3*COLOR_BITS - 1:0] shaded_red, shaded_green, shaded_blue
);

    logic [31:0] dot_product;
    logic [31:0] normalized_dot_product;
    logic [12:0] beam_vector [2:0];

    always_comb begin
        beam_vector = {reflect_point[0] - beam_origin[0], reflect_point[1] - beam_origin[1], reflect_point[2] - beam_origin[2]};
        dot_product = beam_vector[0]*normal_vector[0] + beam_vector[1]*normal_vector[1] + beam_vector[2]*normal_vector[2];
        normalized_dot_product = dot_product / ((beam_vector[0]**2 + beam_vector[1]**2 + beam_vector[2]**2)*(normal_vector[0]**2 + normal_vector[1]**2 + normal_vector[2]**2));
        // I'm aware division is computationally expensive, but I don't see how else to do shading
        shaded_red = red * normalized_dot_product;
        shaded_green = green * normalized_dot_product;
        shaded_blue = blue * normalized_dot_product;
    end

endmodule