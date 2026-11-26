import our_logic_pkg::*;

module sparse_color_mapper #(
    parameter int COLOR_WIDTH = 4
    )(
    input dist_t drawX, drawY,
    input polar_coord_t paddles [0:PADDLE_COUNT-1],
    input cart_coord_t [7:0] paddles_2d [0:PADDLE_COUNT-1],
    input sphere_t ball,
    input logic clk,
    input logic frame_tick,
    input logic reset,
    
    output logic is_object,
    output logic [COLOR_WIDTH-1:0] red, green, blue
);

    logic req;
    always_ff @(posedge clk) begin
        if (frame_tick) begin
            req <= 1'b1;
        end else begin
            req <= 1'b0;
        end
    end

    cart_coord_t beam_origin;
    cart_coord_t [(PADDLE_COUNT*6)-1:0] surface_point;
    always_comb begin
        beam_origin = {0, 0, 20};
        // comment names for each surface point derived from the vertices which enclose it
        for (int i = 0; i < PADDLE_COUNT; i++) begin
            surface_point[0 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta}); // for face 1357
            surface_point[1 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi, paddles[i].theta + PADDLE_HALF_THETA_OFFSET}); // for face 1256
            surface_point[2 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta + PADDLE_THETA_OFFSET}); // for face 2468
            surface_point[3 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_PHI_OFFSET, paddles[i].theta + PADDLE_HALF_THETA_OFFSET}); // for face 3478
            surface_point[4 + i*6] = polar_to_cart({paddles[i].radius, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta + PADDLE_HALF_THETA_OFFSET}); // for face 1234
            surface_point[5 + i*6] = polar_to_cart({paddles[i].radius + PADDLE_HALF_RADIUS_OFFSET, paddles[i].phi + PADDLE_HALF_PHI_OFFSET, paddles[i].theta + PADDLE_HALF_THETA_OFFSET});
        end
    end

    logic [(PADDLE_COUNT*6)-1:0] done;
    polar_coord_t [(PADDLE_COUNT*6)-1:0] light_unit_vector;
    generate // generate for loop structure inspired by the following: https://stackoverflow.com/questions/33899691/instantiate-modules-in-generate-for-loop-in-verilog
        for (genvar i = 0; i < (6 << $clog2(PADDLE_COUNT)); i++) begin : face_vector_calcs
            light_vector #(

            ) face_calcs (
                .clk,
                .beam_origin,
                .surface_point[i],
                .req,
                .reset,

                .done[i],
                .light_unit_vector[i]
            );
        end 
    endgenerate
endmodule