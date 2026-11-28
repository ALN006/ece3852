module dir_search_2d
    import geometry_pkg::*;
    #(  parameter   angle_t             LOWER_BOUND_ANGLE   = '0,
        parameter   angle_t             UPPER_BOUND_ANGLE   = PI    )(
        input       logic               clk,
        input       cart_coord_2d_t     target,
        input       logic               restart,
        output      angle_t             direction
    );
    angle_t upper, lower;
    assign direction = ((lower + upper) >> 1);
    always_ff @(posedge clk) begin 
        if (restart == 1'b1) begin 
            lower <= LOWER_BOUND_ANGLE;
            upper <= UPPER_BOUND_ANGLE;
        end else begin 
            if (det_2d('{ x: cos(direction), y: sin(direction)}, target) > '0) begin 
                lower <= direction;
            end else begin 
                upper <= direction;
            end
        end
    end 
endmodule
