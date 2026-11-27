module dir_search_2d // NOTE: it is neccessary to assert reset to find a new direction
    import geometry_pkg::*;
    #(  parameter   angle_t             LOWER_BOUND_ANGLE   = '0,
        parameter   angle_t             UPPER_BOUND_ANGLE   = PI    )(
        input       logic               clk,
        input       cart_2d_coord_t     target,
        input       logic               reset,
        output      angle_t             direction
    );
    angle_t upper, mid, lower;
    assign mid = ((lower + upper) >> 1);
    always_ff @(posedge clk) begin 
        if (reset == 1'b1) begin 
            lower <= LOWER_BOUND_ANGLE;
            upper <= UPPER_BOUND_ANGLE;
        end else begin 
            if (det_2d('{ x: cos(mid), y: sin(mid)}, target) > '0) begin 
                lower <= mid;
            end else begin 
                upper <= mid;
            end
        end
    end 
    assign direction = mid;
endmodule
