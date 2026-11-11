`define MAX_SIMULTAENEOUS_KEYCODES  6
`define KEYCODE_WIDTH               8

// TODO: determine if we want to GPIO or direct AXI_slave
module top (
    input logic     clk,
    input logic     reset,  // TODO: figure out if this should be active low or asynchronous
    // TODO: consider taking buttons or switches 

    // TODO: add hex seg displays eventually 
    // TODO: check if HDMI outputs belong here
    // TODO: consider adding LEDs 
); 
    // TODO: finish instantiating our logic
    our_logic #(
        .MAX_SIMULTAENEOUS_KEYCODES
        .KEYCODE_WIDTH
    ) 3d_polar_pong_logic (
        .clk,
        .pix_clk,
        .draw_now,
        .drawX, .drawY,

        .red, .green, .blue
    );

    clk_wiz_0 clk_wiz (
        .reset,
        .clk_in1(clk),

        .locked,
        .clk_out1(clk_25MHz), .clk_out2(clk_125MHz)
    ); 

    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
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
        .rst(reset_ah),
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
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

    mb_block mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
    
endmodule
