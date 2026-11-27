module forward_index_2d // NOTE: doesnt currently support lookups more than one line ahead
    #(  parameter   type        index_1d    = logic[11:0],
        parameter   int         LOOKAHEAD   = 1,
        parameter   index_1d    BOUND1      = 12'd(1024),
        parameter   index_1d    BOUND2      = 12'd(1024)    )(
        input       index_1d    x, y,
        output      index_1d    fwd_x, fwd_y
    );
    localparam int index_1d_width = $bits(index_1d);

    logic [index_1d_width:0] next_x, next_y; 
    assign next_x = {1'b0, x} + (index_1d_width + 1)'(LOOKAHEAD);
    assign next_y = y + index_1d'(1);
    
    always_comb begin 
        fwd_y = y;
        if (next_x < (index_1d_width + 1)'(BOUND1)) begin 
            fwd_x = index_1d'(next_x);
        end else begin
            fwd_x = index_1d'(next_x - (index_1d_width + 1)'(BOUND1));
            fwd_y = (next_y < (index_1d_width + 1)'(BOUND2)) ? index_1d'(next_y) : index_1d'(0);
        end
    end
endmodule

