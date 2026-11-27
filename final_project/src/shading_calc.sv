import our_logic_pkg::*; // TODO: remeber to have a conversation about not doing this with nick

// take in the 100% lit up color, then desaturate as needed depending on light reflections
// TODO: pedantically ask nick to define desaturation, and use the dot product module

module shading_calc #(
    parameter int COLOR_WIDTH            = 4,
)(
    input cart_coord_t light_unit_vector,
    input cart_coord_t normal_vector,
    input logic [COLOR_WIDTH - 1:0] red, green, blue,

    output logic [COLOR_WIDTH - 1:0] shaded_red, shaded_green, shaded_blue
);

    dot_t dot_product;
    logic signed [DIST_WIDTH:0] shade_by; // will have DIST_WIDTH + 1 elements to prevent any possible overflow issues
    logic [COLOR_WIDTH+DIST_WIDTH-1:0] extend_red, extend_green, extend_blue;
    always_comb begin
        dot_product = dot(light_unit_vector, normal_vector);
        shade_by = dot_product >> DIST_WIDTH; // same as square root given locked magnitudes
        if (shade_by > 0) begin
            shaded_red = (red * shade_by) >> DIST_WIDTH;
            shaded_green = (green * shade_by) >> DIST_WIDTH;
            shaded_blue = (blue * shade_by) >> DIST_WIDTH;
        end else begin
            {shaded_red, shaded_green, shaded_blue} = 12'h000;
        end
    end
endmodule