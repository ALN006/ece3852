//-------------------------------------------------------------------------
//      VGA controller                                                   --                                                               --
//      reference: http://www.xilinx.com/bvdocs/userguides/ug130.pdf     --
//                 http://www.epanorama.net/documents/pc/vga_timing.html --
//                                                                       --
//      note: The standard is changed slightly because of 25 mhz instead --
//            of 25.175 mhz pixel clock. Refresh rate drops slightly.    --
//-------------------------------------------------------------------------


module  vga_controller ( 
    input   logic           pixel_clk, reset,   // 50 MHz clock, reset signal
    output  logic           hs,                 // Horizontal sync pulse.  Active low
				            vs,                 // Vertical sync pulse.  Active low
					        active_nblank,      // High = active, low = blanking interval
					        sync,               // Composite Sync signal.  Active low.  We don't use it in this lab, 
                                                // but the video DAC on the DE2 board requires an input for it.

	output  logic   [9:0]   drawX, drawY      // coordinates
);
    assign sync = 1'b0; //Disable Composite Sync
    
    // 800 horizontal pixels indexed 0 to 799
    // 525 vertical pixels indexed 0 to 524
    // ^ TF ?
    parameter [9:0] hpixels = 10'b1100011111;
    parameter [9:0] vlines = 10'b1000001100;
	 
	// horizontal pixel and vertical line counters
    logic [9:0] hc, vc;
    
	// signal indicates if ok to display color for a pixel
	logic display; 
   
	//Runs the horizontal counter  when it resets vertical counter is incremented
    always_ff @ (posedge pixel_clk or posedge reset ) begin: counter_proc
		if (reset) begin 
			hc <= 10'b0000000000;
			vc <= 10'b0000000000;
        end else if ( hc == hpixels ) begin //If hc has reached the end of pixel count
			hc <= 10'b0000000000;
            vc <= (vc == vlines) ? '0 : vc + 1;
        end else begin
			hc <= (hc + 1);
        end
	end 
   
    assign drawX = hc;
    assign drawY = vc;
   
	//horizontal sync pulse is 96 pixels long at pixels 656-752
    //(signal is registered to ensure clean output waveform)

    //vertical sync pulse is 2 lines(800 pixels) long at line 490-491
    //(signal is registered to ensure clean output waveform)

    always_ff @ (posedge reset or posedge pixel_clk ) begin : hsync_proc
        if ( reset ) begin
            hs <= 1'b0;
            vs <= 1'b0;
        end else begin
            hs <= (((hc + 1) >= 10'b1010010000) & ((hc + 1) < 10'b1011110000)) ? 1'b0 : 1'b1;
            vs <= ( ((vc + 1) == 9'b111101010) | ((vc + 1) == 9'b111101011) ) ? 1'b0 : 1'b1;
        end
    end

    //only display pixels between horizontal 0-639 and vertical 0-479 (640x480)
    //(This signal is registered within the DAC chip, so we can leave it as pure combinational logic here)    
    always_comb display = ( (hc >= 10'b1010000000) | (vc >= 10'b0111100000) ) ? 1'b0 : 1'b1;
    assign active_nblank = display;   
     
endmodule
