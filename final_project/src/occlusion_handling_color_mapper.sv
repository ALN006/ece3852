// Looks at where the objects are in frame, determines pixel colors based on that
import our_logic_types_pkg::*;
/* verilator lint_off UNUSEDSIGNAL */ // TODO: actually implement this module
module occlusion_handling_color_mapper #(
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
    // assign  read_addresses       = '{ MAX_OBJS_ON_SCREEN { {(ADDRESS_BITS + 1)/2 {2'b10}} } };
    // assign  {red, green, blue}   = { (3 * COLOR_BITS)/2 {2'b10}};


// TODO: expand to two paddles
    our_logic_types_pkg::point_3d_t [7:0] paddle_0_vertices;
    our_logic_types_pkg::point_3d_t [7:0] paddle_1_vertices;
    logic [MAX_OBJS_ON_SCREEN-2:0] length_vectors [2:0]; // ASSUMES 1 BALL
    logic depth_vector [2:0];

    always_comb begin // calculate the cross product combinationally to make sure the numbers are ready as soon as the pixel clock rises
        for (integer i = 0; i < MAX_OBJS_ON_SCREEN-1; i++) begin
            depth_vector = {paddles[i].v1.x - paddles[i].v0.x, paddles[i].v1.y - paddles[i].v0.y, paddles[i].v1.z - paddles[i].v0.z};
            length_vectors[i][0] = {depth_vector[1] * paddles[i].width_vector.z - depth_vector[2] * paddles[i].width_vector.y};
            length_vectors[i][1] = {depth_vector[2] * paddles[i].width_vector.x - depth_vector[0] * paddles[i].width_vector.z};
            length_vectors[i][2] = {depth_vector[0] * paddles[i].width_vector.y - depth_vector[1] * paddles[i].width_vector.x};
        end
    end

    always_ff @(posedge pix_clk) begin // calculate the 8 vertices of the cuboids each cycle of pixel clock
        paddle_0_vertices[0]    <= {paddles[0].v0.x, paddles[0].v0.y, paddles[0].v0.z}
        paddle_0_vertices[1]    <= {paddles[0].v1.x, paddles[0].v1.y, paddles[0].v1.z}
        paddle_0_vertices[2]    <= {paddles[0].v0.x + paddles[0].width_vector.x, paddles[0].v0.y + paddles[0].width_vector.y, paddles[0].v0.z + paddles[0].width_vector.z}
        paddle_0_vertices[3]    <= {paddles[0].v1.x + paddles[0].width_vector.x, paddles[0].v1.y + paddles[0].width_vector.y, paddles[0].v1.z + paddles[0].width_vector.z}
        paddle_0_vertices[4]    <= {paddles[0].v0.x + length_vectors[0][0], paddles[0].v0.y + length_vectors[0][1], paddles[0].v0.z + length_vectors[0][2]}
        paddle_0_vertices[5]    <= {paddles[0].v1.x + length_vectors[0][0], paddles[0].v1.y + length_vectors[0][1], paddles[0].v1.z + length_vectors[0][2]}
        paddle_0_vertices[6][0] <= paddles[0].v0.x + paddles[0].width_vector.x + length_vectors[0][0];
        paddle_0_vertices[6][1] <= paddles[0].v0.y + paddles[0].width_vector.y + length_vectors[0][1];
        paddle_0_vertices[6][2] <= paddles[0].v0.z + paddles[0].width_vector.z + length_vectors[0][2];
        paddle_0_vertices[7][0] <= paddles[0].v1.x + paddles[0].width_vector.x + length_vectors[0][0];
        paddle_0_vertices[7][1] <= paddles[0].v1.y + paddles[0].width_vector.y + length_vectors[0][1];
        paddle_0_vertices[7][2] <= paddles[0].v1.z + paddles[0].width_vector.z + length_vectors[0][2];

        paddle_1_vertices[0]    <= {paddles[1].v0.x, paddles[1].v0.y, paddles[1].v0.z}
        paddle_1_vertices[1]    <= {paddles[1].v1.x, paddles[1].v1.y, paddles[1].v1.z}
        paddle_1_vertices[2]    <= {paddles[1].v0.x + paddles[1].width_vector.x, paddles[1].v0.y + paddles[1].width_vector.y, paddles[1].v0.z + paddles[1].width_vector.z}
        paddle_1_vertices[3]    <= {paddles[1].v1.x + paddles[1].width_vector.x, paddles[1].v1.y + paddles[1].width_vector.y, paddles[1].v1.z + paddles[1].width_vector.z}
        paddle_1_vertices[4]    <= {paddles[1].v0.x + length_vectors[1][0], paddles[1].v0.y + length_vectors[1][1], paddles[1].v0.z + length_vectors[1][2]}
        paddle_1_vertices[5]    <= {paddles[1].v1.x + length_vectors[1][0], paddles[1].v1.y + length_vectors[1][1], paddles[1].v1.z + length_vectors[1][2]}
        paddle_1_vertices[6][0] <= paddles[1].v0.x + paddles[1].width_vector.x + length_vectors[1][0];
        paddle_1_vertices[6][1] <= paddles[1].v0.y + paddles[1].width_vector.y + length_vectors[1][1];
        paddle_1_vertices[6][2] <= paddles[1].v0.z + paddles[1].width_vector.z + length_vectors[1][2];
        paddle_1_vertices[7][0] <= paddles[1].v1.x + paddles[1].width_vector.x + length_vectors[1][0];
        paddle_1_vertices[7][1] <= paddles[1].v1.y + paddles[1].width_vector.y + length_vectors[1][1];
        paddle_1_vertices[7][2] <= paddles[1].v1.z + paddles[1].width_vector.z + length_vectors[1][2];
    end


    // logic [COORD_BITS-1:0] consider_object;
    // 
    // always_comb begin
    //     for (int i = 0; i < MAX_OBJS_ON_SCREEN; i++) begin
    //         // These are unsigned values, if we subtract the wrong direction, we risk values wrapping back around
    //         if (drawX < obj_coords[4*i] && drawY < obj_coords[4*i+1]) begin
    //             if ((obj_coords[4*i] - drawX < CHECK_RADIUS) && (obj_coords[4*i + 1] - drawY < CHECK_RADIUS)) begin
    //                 consider_object[i] = 1'b1;
    //             end else begin
    //                 consider_object[i] = 1'b0;
    //             end
    //         end else if (drawX < obj_coords[4*i] && drawY > obj_coords[4*i+1]) begin
    //             if ((obj_coords[4*i] - drawX < CHECK_RADIUS) && (drawY - obj_coords[4*i + 1] < CHECK_RADIUS)) begin
    //                 consider_object[i] = 1'b1;
    //             end else begin
    //                 consider_object[i] = 1'b0;
    //             end
    //         end else if (drawX > obj_coords[4*i] && drawY < obj_coords[4*i+1]) begin
    //             if ((drawX - obj_coords[4*i] < CHECK_RADIUS) && (obj_coords[4*i + 1] - drawY < CHECK_RADIUS)) begin
    //                 consider_object[i] = 1'b1;
    //             end else begin
    //                 consider_object[i] = 1'b0;
    //             end
    //         end else begin
    //             if ((drawX - obj_coords[4*i] < CHECK_RADIUS) && (drawY - obj_coords[4*i + 1] < CHECK_RADIUS)) begin
    //                 consider_object[i] = 1'b1; 
    //             end else begin
    //                 consider_object[i] = 1'b0;
    //             end
    //         end
    //     end
    //     logic [MAX_OBJS_ON_SCREEN-1:0] considered_idx; // This signal is oversized, but I don't think that's our deepest issue
     
    //     for (int i = 0; i < MAX_OBJS_ON_SCREEN; i++) begin
    //         if (consider_object[i]) begin
    //             read_addresses[considered_idx] = // TODO: implement addressing to properly pull out the shape data from memory;
    //         end
    //     end
    // end

    // always_ff @(posedge pix_clk) begin
    //     consider_object <= {COORD_BITS{0}}; // clear before evaluating each new pixel
    // end

endmodule
