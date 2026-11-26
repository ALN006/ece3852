module unit_vector_search_2d
    import geometry_pkg::*;
    #(  parameter   dist_t              UNIT_RADIUS         = (1 << DIST_WIDTH - 1); // this first parameter is like precision control
        parameter   angle_t             LOWER_BOUND_ANGLE   = '0,
        parameter   angle_t             UPPER_BOUND_ANGLE   = PI,
        localparam  integer             cycles              = $clog2(upper_bound.angle) ) (
        input       logic               clk,
        input       cart_2d_coord_t     target,
        input       logic               reset,
        output      polar_2d_coord_t    unit_vector
    );
    angle_t                 curr_lower;
    polar_2d_coord_t        curr;
    angle_t                 curr_upper;
    logic [cycles - 1 : 0 ] cycle;
    cart_2d_coord_t         unit_vector_cart;
    assign curr.radius      = UNIT_RADIUS;
    assign unit_vector_cart = polar_to_cart(curr);
    assign unit_vector      = curr;
    always_ff @(posedge clk) begin 
        curr.angle <= ((curr_upper + curr_lower) >> 1);
        if (reset == 1'b1) begin 
            {cycle} = '0;
            curr_lower <= LOWER_BOUND_ANGLE;
            curr_upper <= UPPER_BOUND_ANGLE;
        end else begin 
            cycle <= { 1'b0, cycle[ cycles - 1 : 1 ] };
            if (det_2d(unit_vector_cart, target) > '0) begin 
                curr_upper <= curr.angle;
            end else begin 
                curr_lower <= curr.angle;
            end
        end
    end 
endmodule
