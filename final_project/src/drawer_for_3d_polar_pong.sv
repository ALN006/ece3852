module drawer_for_3d_polar_pong (
    input logic pix_clk,
    input logic [31:0] read_data, // assuming 32-bit data bus akin to lab7
    input logic [9:0] obj_z_coords [0:13],

    output logic [15:0] read_addresses, // assuming 16-bit address bus akin to lab7
    output logic [3:0] red, green, blue

);

endmodule