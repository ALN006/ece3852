`define MAX_SIMULTAENEOUS_KEYCODES  6
`define KEYCODE_WIDTH               8

// TODO: determine if we want to GPIO or direct AXI_slave
module top (
    input logic     clk,
    input logic     reset_rtl_0,  // TODO: figure out if this should be active low or asynchronous
    
    output logic hdmi_tmds_clk_n, hdmi_tmds_clk_p,
    output logic [2:0] hdmi_tmds_tx_n, hdmi_tmds_tx_p
    // TODO: consider taking buttons or switches 

    // TODO: add hex seg displays eventually 
    // TODO: check if HDMI outputs belong here
    // TODO: consider adding LEDs 
); 
    // TODO: finish instantiating our logic

    clk_wiz_0 clk_wiz (
        .reset,
        .clk_in1(clk),

        .locked,
        .clk_out1(clk_25MHz), .clk_out2(clk_125MHz)
    ); 

    logic hsync, vsync, vde;
    logic [9:0] drawX, drawY;
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset_a(reset),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        
        .drawX(drawX),
        .drawY(drawY)
    );  

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        .rst(reset),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_tx_p),         
        .TMDS_DATA_N(hdmi_tmds_tx_n)          
    );

//    logic [31:0] keycode0_gpio, keycode1_gpio;

    logic [3:0] red, green, blue; // TODO: get `color_bits defined throughout our modules
    our_logic ours (
        .clk,
        .pix_clk(clk_25MHz),
        .frame_clk(vsync),
        .draw_now, // TODO: figure out what this needs
        .drawX, .drawY,
        .keycodes, // TODO: set up the structure to pull these from MicroBlaze GPIOs akin to Lab 6

        .red, .green, .blue
    );

endmodule
