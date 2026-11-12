// TODO: test this module, it may have broken in manual reformating
//-------------------------------------------------------------------------
//      VGA controller                                                   --                                                               --
//      reference: http://www.xilinx.com/bvdocs/userguides/ug130.pdf     --
//                 http://www.epanorama.net/documents/pc/vga_timing.html --
//                                                                       --
//      note: The standard is changed slightly because of 25 mhz instead --
//            of 25.175 mhz pixel clock. Refresh rate drops slightly.    --
//-------------------------------------------------------------------------

module  vga_controller ( 
    input   logic       pixel_clk, reset_a,
    output  logic       hs,                 // Horizontal sync pulse.  Active low
				        vs,                 // Vertical sync pulse.  Active low
					    active_nblank,      // High = active, low = blanking interval // signal indicates if ok to display color for a pixel 
					    sync,               // Composite Sync signal.  Active low.  We don't use it in this lab, 
                                            // but the video DAC on the DE2 board requires an input for it.

	output  logic [9:0] drawX, drawY        // coordinates // horizontal pixel and vertical line counters
);
    //only display pixels between horizontal 0-639 and vertical 0-479 (640x480)
    //(This signal is registered within the DAC chip, so we can leave it as pure combinational logic here)   //TODO: figure out what the DAC chip is 
    assign active_nblank = ~( (drawX >= 10'd640) | (drawY >= 10'd480) );
    assign sync = 1'b0; //Disable Composite Sync

    localparam [9:0] hpixels    = 10'd799;  // 800 horizontal pixels indexed 0 to 799
    localparam [9:0] vlines     = 10'd524;   // 525 vertical pixels indexed 0 to 524
   
	//horizontal sync pulse is 96 pixels long at pixels 656-752 (signal is registered to ensure clean output waveform)
    //vertical sync pulse is 2 lines(800 pixels) long at line 490-491 (signal is registered to ensure clean output waveform)
    always_ff @ (posedge pixel_clk or posedge reset_a ) begin: counter_proc
		if (reset_a) begin 
            { drawX, drawY, hs, vs } <= '0;
        end else begin 
            hs <= ~( ( ( drawX + 1 ) >= 10'd656 ) & ( ( drawX + 1 ) <  10'd752 ) );
            vs <= ~( ( ( drawY + 1 ) == 10'd490 ) | ( ( drawY + 1 ) == 10'd491 ) );
            if ( drawX == hpixels ) begin //If drawX has reached the end of pixel count
                drawX <= '0;
                drawY <= (drawY == vlines) ? '0 : drawY + 1;
            end else begin
                drawX <= (drawX + 1);
            end
        end
	end 
endmodule
