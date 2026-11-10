module frame_gen_for_3d_polar_pong (
    input logic clk,
    input logic [5:0] keycodes,
    
    output logic [31:0] write_data,
    output logic [9:0] obj_z_coords [0:13],

);

    assign write_data = 32'hAAAAAAAA;
    always_comb begin
        for (integer i = 0; i < 10; i = i + 1) begin
            obj_z_coords[i] = {14{0}};
        end
    end
endmodule