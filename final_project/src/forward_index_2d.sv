module forward_index_2d // NOTE: doesnt currently support lookups more than one line ahead
    #(  parameter   type        INDEX_1D    = logic[11:0],
        parameter   int         LOOKAHEAD   = 1,
        parameter   INDEX_1D    BOUND1      = 12'd1024,
        parameter   INDEX_1D    BOUND2      = 12'd1024    )(
        input       INDEX_1D    x, y,
        output      INDEX_1D    fwd_x, fwd_y
    );
    localparam int INDEX_1D_width = $bits(INDEX_1D);

    logic [INDEX_1D_width:0] next_x, next_y; 
    assign next_x = {1'b0, x} + (INDEX_1D_width + 1)'(LOOKAHEAD);
    assign next_y = y + INDEX_1D'(1);
    
    always_comb begin 
        fwd_y = y;
        if (next_x < (INDEX_1D_width + 1)'(BOUND1)) begin 
            fwd_x = INDEX_1D'(next_x);
        end else begin
            fwd_x = INDEX_1D'(next_x - (INDEX_1D_width + 1)'(BOUND1));
            fwd_y = (next_y < (INDEX_1D_width + 1)'(BOUND2)) ? INDEX_1D'(next_y) : INDEX_1D'(0);
        end
    end
endmodule
