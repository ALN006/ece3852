`define max_objs_on_screen  13 
`define color_bits          4
`define coord_bits          10

// TODO: determine if we want to GPIO or direct AXI_slave
module top (
    input logic     clk,
    input logic     reset,  // TODO: figure out if this should be active low or asynchronous
    // TODO: consider taking buttons or switches 

    // TODO: add hex seg displays eventually 
    // TODO: confirm that HDMI outputs dont belong here
    // TODO: consider adding LEDs 
);
    logic [ `color_bits - 1 : 0 ] red, green, blue;
    drawer_for_3d_polar_pong draw_logic (   // TODO: implement this
        .pix_clk,           // TODO: consider passing in faster clock
        .read_data(data),
        .obj_z_coords,

        .read_addresses,
        .red, .green, .blue 
    ); 

    logic [ `color_bits - 1 : 0 ] data;
    memory per_object_storage [`max_objs_on_screen - 1:0] (      // TODO: implement this as a wrapper
        .clk, 
        .address,
        .enable,
        .w_data,

        .r_data      // TODO: check that this is an inout pin
    );

    logic [ `coord_bits - 1 : 0 ] obj_z_coords [ 0 : `max_objs_on_screen - 1 ];
    frame_gen_for_3d_polar_pong frame_gen_logic (
        .clk,
        .keycodes,
        
        .write_data(data), // data is declared above memory
        .obj_z_coords
    );

    clk_wiz_0 clk_wiz (
        .reset,
        .clk_in1(axi_aclk),

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
